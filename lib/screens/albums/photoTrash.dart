import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:shared_preferences/shared_preferences.dart';

class PhotoTrash extends StatefulWidget {
  final argsData;
  PhotoTrash({this.argsData});

  @override
  _PhotoTrash createState() => new _PhotoTrash();
}

class _PhotoTrash extends State<PhotoTrash> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  var _photoTrashList = [];

  @override
  void initState() {
    super.initState();
    fetchTrashPhoto();
  }

  Future fetchTrashPhoto() async {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');
    var id = widget.argsData["arrayData"]["id"];
    var url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/photo/album/$id/trash/list");
    var getAlbums = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    });

    if (getAlbums.statusCode == 200) {
      var parsedJson = json.decode(getAlbums.body);
      setState(() {
        _photoTrashList = parsedJson['data'];
      });

      print(_photoTrashList);
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
            onPressed: () => {
                  if (widget.argsData["isShare"])
                    {
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pushNamed('/shared',
                            arguments: widget.argsData["arrayData"])
                    }
                  else
                    {
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pushNamed('/photos',
                            arguments: widget.argsData["arrayData"])
                    }
                }),
        title: const Text('Corbeil photos'),
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
