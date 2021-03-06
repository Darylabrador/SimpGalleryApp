import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpgalleryapp/components/dialog/DialogImage.dart';
import 'package:simpgalleryapp/components/dialog/DialogShareAlbum.dart';
import 'package:simpgalleryapp/components/dialog/DialogSettingShare.dart';

class Photos extends StatefulWidget {
  final arrayData;
  Photos({this.arrayData});

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  var _albumData = [];

  var _imageCoverUpdate;
  var imageCoverPicker;

  String comments = "";

  @override
  void initState() {
    super.initState();
    fetchAlbumData();
  }

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

  Future<void> _updateCoverImage(file) async {
    Navigator.of(context).pop();
    setState(() {
      _imageCoverUpdate = file;
    });
  }

  Future editCoverDialog() {
    var token = storage.getItem('SimpGalleryToken');
    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Modification de la couverture",
            style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                  height: _imageCoverUpdate != null ? 300 : null,
                  width: 500,
                  child: Stack(children: <Widget>[
                    Container(
                      child: _imageCoverUpdate != null
                          ? Image.file(_imageCoverUpdate, fit: BoxFit.cover)
                          : null,
                    ),
                    Center(
                        child: OutlinedButton(
                      onPressed: () async {
                        imageCoverPicker = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        await _updateCoverImage(imageCoverPicker);
                        await editCoverDialog();
                      },
                      child: Text("Selectionner une image",
                          style: TextStyle(color: Colors.black)),
                    )),
                  ])),
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
              _updateCoverImage(null);
            },
          ),
          OutlinedButton(
            child: Text(
              'Valider',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () async {
              var url =
                  Uri.parse("${DotEnv.env['DATABASE_URL']}/api/album/cover");
              var request = http.MultipartRequest(
                'POST',
                url,
              );
              request.headers["authorization"] = "Bearer " + token;
              request.fields['albumId'] = widget.arrayData["id"].toString();
              request.files.add(await http.MultipartFile.fromPath(
                  'cover', _imageCoverUpdate.path));
              await request.send();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future displayFullScreenImage(content) {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');
    var _commentList = content["comments"];

    return showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
            backgroundColor: Colors.black87,
            body: ListView(
              children: [
                Container(
                  height: 360,
                  width: 500,
                  child: Image.network(
                      "${DotEnv.env['DATABASE_URL']}/img/" + content['label'],
                      height: 400,
                      width: 500,
                      fit: BoxFit.cover),
                ),
                Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 152,
                        width: 500,
                        decoration: BoxDecoration(color: Colors.white),
                        child: content["comments"].length != 0
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.all(8),
                                itemCount: _commentList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onLongPress: () async {},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_commentList[index]['comment']
                                            .toString()),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                })
                            : null,
                      ),
                      Divider(),
                      Container(
                          height: 50,
                          width: 500,
                          padding: EdgeInsets.only(left: 3.0),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 280,
                                child: TextFormField(
                                    expands: true,
                                    minLines: null,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Ecrivez votre commentaire'),
                                    onChanged: (val) => comments = val),
                              ),
                              Container(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      var url = Uri.parse(
                                          "${DotEnv.env['DATABASE_URL']}/api/comment/create");
                                      var response = await http.post(url,
                                          body: json.encode({
                                            'photoId': content["id"].toString(),
                                            'comment': comments,
                                          }),
                                          headers: {
                                            "Content-Type": "application/json",
                                            "Accept": "application/json",
                                            "Authorization": "Bearer " + token
                                          });

                                      if (response.statusCode == 200) {
                                        var parsedJson =
                                            json.decode(response.body);

                                        showToast(
                                          parsedJson['message'],
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          reverseAnimation:
                                              StyledToastAnimation.fade,
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
                                            ..pushNamed('/photos',
                                                arguments: widget.arrayData);
                                        }
                                      } else {
                                        showToast(
                                          "Une erreur est survenue",
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          reverseAnimation:
                                              StyledToastAnimation.fade,
                                          position: StyledToastPosition.bottom,
                                          animDuration: Duration(seconds: 1),
                                          duration: Duration(seconds: 4),
                                          curve: Curves.elasticOut,
                                          reverseCurve: Curves.linear,
                                        );
                                      }
                                    },
                                    child:
                                        Icon(Icons.send, color: Colors.white),
                                  )),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            )));
  }

  Future deleteSingleImageDialog(photoId) {
    var token = storage.getItem('SimpGalleryToken');
    return showDialog<String>(
      barrierDismissible: false,
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
  Widget build(BuildContext context) {
    // token for bearer token
    var token = storage.getItem('SimpGalleryToken');
    var userConnected = storage.getItem('SimpGalleryUser');
    var url;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context)
              ..pop()
              ..pop()
              ..pushNamed('/home'),
          ),
          title: const Text('Albums'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'deconnexion',
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("tok");
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
                          onDoubleTap: () {
                            editCoverDialog();
                          },
                          child: _imageCoverUpdate == null
                              ? Image.network(
                                  "${DotEnv.env['DATABASE_URL']}/img/" +
                                      widget.arrayData['cover'],
                                  height: 200,
                                  width: 500,
                                  fit: BoxFit.fill)
                              : Image.file(_imageCoverUpdate,
                                  height: 200, width: 500, fit: BoxFit.fill)),
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
                        onLongPress: () {
                          deleteSingleImageDialog(_albumData[index]['id']);
                        },
                        onDoubleTap: () {
                          displayFullScreenImage(_albumData[index]);
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
            child: DialogSettingShare(
              albumId: widget.arrayData['id'],
              arrayData: widget.arrayData,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: userConnected == widget.arrayData["owner"]["id"]
                  ? DialogShareAlbum(allData: widget.arrayData)
                  : Text("")),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/trash/photos', arguments: {
                  "arrayData" : widget.arrayData,
                  "isShare": false
                });
              },
              heroTag: "trash_photo",
              child: Icon(Icons.delete),
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
