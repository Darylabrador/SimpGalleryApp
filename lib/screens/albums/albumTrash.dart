import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:shared_preferences/shared_preferences.dart';

class AlbumTrash extends StatefulWidget {
  @override
  _AlbumTrash createState() => new _AlbumTrash();
}

class _AlbumTrash extends State<AlbumTrash> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  var _albumTrashList = [];

  @override
  void initState() {
    super.initState();
    fetchTrashAlbum();
  }

  Future fetchTrashAlbum() async {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');

    var url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/album/trash/list/");
    var getAlbums = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    });

    if (getAlbums.statusCode == 200) {
      var parsedJson = json.decode(getAlbums.body);
      setState(() {
        _albumTrashList = parsedJson['data'];
      });

      print(_albumTrashList);
    }
  }

  Future restoreDialog(albumId) {
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
                  'Voulez-vous vraiment restaurer cet album ?',
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
                  "${DotEnv.env['DATABASE_URL']}/api/album/$albumId/trash/restore");
              var response = await http.put(url, body: null, headers: {
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
                    ..pushNamed('/home');
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

  Future confirmDeleteDialog(albumId) {
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
                  'Voulez-vous vraiment supprimer cet album ?',
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
                  "${DotEnv.env['DATABASE_URL']}/api/album/$albumId/delete/confirm");
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
                    ..pushNamed('/home');
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
    var token = storage.getItem('SimpGalleryToken');
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
        title: const Text("Corbeil d'albums"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'deconnexion',
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("tok");
              var url =
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
          margin: EdgeInsets.only(bottom: 80.0),
          height: 500,
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: _albumTrashList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onLongPress: () {
                  confirmDeleteDialog(_albumTrashList[index]['id'].toString());
                },
                onDoubleTap: () {
                  restoreDialog(_albumTrashList[index]['id'].toString());
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.network(
                          "${DotEnv.env['DATABASE_URL']}/img/" +
                              _albumTrashList[index]['cover'],
                          height: 110,
                          width: 200,
                          fit: BoxFit.cover),
                      Text(_albumTrashList[index]['label'].toString())
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
