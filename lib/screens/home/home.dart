import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

// Widgets
import './albums_widget.dart';
import './shared_widget.dart';

// Models
import 'package:client/models/album.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  var _album = [];
  var _albumShare = [];

  final LocalStorage storage = new LocalStorage('sharePhoto');

  @override
  void initState() {
    super.initState();
    fetchAlbum();
    fetchShareAlbum();
  }

  Future fetchAlbum() async {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');

    var url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/album/list");
    var getAlbums = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    });

    if (getAlbums.statusCode == 200) {
      var parsedJson = json.decode(getAlbums.body);
      setState(() {
        _album = parsedJson['data'];
      });
    }
  }

  Future fetchShareAlbum() async {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');

    var url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/album/share/list");
    var getShares = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    });

    if (getShares.statusCode == 200) {
      var parsedJson = json.decode(getShares.body);
      setState(() {
        _albumShare = parsedJson['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // token for bearer
    var token = storage.getItem('SimpGalleryToken');
    var url;

    return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Navigator.pushNamed(context, '/profil');
                },
              );
            },
          ),
          title: const Text('SimpGalleryApp'),
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
        body: Column(children: <Widget>[
          Container( child: AlbumsWidget(arrayData: _album)),
          Container( child: SharedWidget(arrayData: _albumShare)),
        ]),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          // Container(
          //   margin: const EdgeInsets.only(right: 10.0),
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/create/album');
          //     },
          //     child: Icon(Icons.settings),
          //     backgroundColor: Colors.deepOrange,
          //   ),
          // ),

          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create/album');
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.deepOrange,
          ),
        ]));
  }
}
