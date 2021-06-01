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
      body: null,
    );
  }
}
