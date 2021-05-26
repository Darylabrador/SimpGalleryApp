import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:image_picker/image_picker.dart';

import '../../components/dialog/DialogImage.dart';

class Photos extends StatefulWidget {
  final arrayData;
  Photos({this.arrayData});

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  var _albumData = [];

  Future fetchAlbumData() async {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');

    var url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/photo/list/" +
        widget.arrayData['id'].toString());
    var getAlbums = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    });

    if (getAlbums.statusCode == 200) {
      var parsedJson = json.decode(getAlbums.body);
      setState(() {
        _albumData = parsedJson['data'];
      });
    }
  }

  Future renderDialog(photoId) {
    var token = storage.getItem('SimpGalleryToken');
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  'Voulez-vous vraiment supprimer cette photo ?',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          OutlinedButton(
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.black38),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          OutlinedButton(
            child: Text(
              'Valider',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () async {
              var url = Uri.parse(
                  "${DotEnv.env['DATABASE_URL']}/api/photo/delete/$photoId");
              var response = await http.delete(url, headers: {
                "Accept": "application/json",
                "Authorization": "Bearer " + token
              });
              if (response.statusCode == 200) {
                var parsedJson = json.decode(response.body);

                showToast(
                  parsedJson['message'],
                  context: context,
                  animation: StyledToastAnimation.scale,
                  reverseAnimation: StyledToastAnimation.fade,
                  position: StyledToastPosition.bottom,
                  animDuration: Duration(seconds: 1),
                  duration: Duration(seconds: 4),
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.linear,
                );

                if (parsedJson['success']) {
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pushNamed('/photos', arguments: widget.arrayData);
                }
              } else {
                showToast(
                  "Une erreur est survenue",
                  context: context,
                  animation: StyledToastAnimation.scale,
                  reverseAnimation: StyledToastAnimation.fade,
                  position: StyledToastPosition.bottom,
                  animDuration: Duration(seconds: 1),
                  duration: Duration(seconds: 4),
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.linear,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAlbumData();
  }

  @override
  Widget build(BuildContext context) {
    // token for bearer token
    var token = storage.getItem('SimpGalleryToken');
    var url;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Albums'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'deconnexion',
              onPressed: () async {
                url =
                    Uri.parse("${DotEnv.env['DATABASE_URL']}/api/deconnexion");
                await http.get(url, headers: {
                  "Accept": "application/json",
                  "Authorization": "Bearer " + token
                });
                await storage.clear();
                await Navigator.pushNamed(context, '/logging');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                    height: 200,
                    width: 500,
                    child: Stack(children: <Widget>[
                      GestureDetector(
                        onLongPress: () {
                          print('edit cover');
                          print(widget.arrayData);
                        },
                        child: Image.network(
                            "${DotEnv.env['DATABASE_URL']}/img/" +
                                widget.arrayData['cover'],
                            height: 200,
                            width: 500,
                            fit: BoxFit.fill),
                      ),
                    ])),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Photos',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: 100,
                            child: Divider(color: Colors.black),
                          ),
                        ])),
                Container(
                  margin: EdgeInsets.only(bottom: 80.0),
                  height: 500,
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemCount: _albumData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onDoubleTap: () {
                          renderDialog(_albumData[index]['id']);
                        },
                        onLongPress: () {
                          print('detail');
                          print(_albumData[index]);
                        },
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Image.network(
                                  "${DotEnv.env['DATABASE_URL']}/img/" +
                                      _albumData[index]['label'],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create/album');
              },
              heroTag: 'setting',
              child: Icon(Icons.settings),
              backgroundColor: Colors.deepOrange,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create/album');
              },
              heroTag: 'share',
              child: Icon(Icons.share),
              backgroundColor: Colors.deepOrange,
            ),
          ),
          Container(
            child: DialogImage(
                albumId: widget.arrayData['id'],
                allData: widget.arrayData,
                isShare: false),
          )
        ]));
  }
}
