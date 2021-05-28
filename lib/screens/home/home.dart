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
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

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
  final _formKey = GlobalKey<FormState>();

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
    var isNeedToVerify = storage.getItem('SimpGalleryMailVerify');
    String jeton = "";

    var url;

    Future renderDialog() {
      return showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Rejoindre un album", textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Jeton d'autorisation",
                              border: OutlineInputBorder()),
                          validator: (val) =>
                              val!.isEmpty ? 'Saisir le jeton' : null,
                          onChanged: (val) => jeton = val,
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
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
                Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pushNamed('/home');
              },
            ),
            OutlinedButton(
              child: Text(
                'Valider',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var url = Uri.parse(
                      "${DotEnv.env['DATABASE_URL']}/api/album/share/confirm");
                  var response = await http.post(url, body: {
                    'jeton': jeton,
                  }, headers: {
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
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Container(child: AlbumsWidget(arrayData: _album)),
          Container(child: SharedWidget(arrayData: _albumShare)),
        ]),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: isNeedToVerify
                ? Text("")
                : FloatingActionButton(
                    onPressed: () {
                      renderDialog();
                    },
                    heroTag: "join_album",
                    child: Icon(Icons.people),
                    backgroundColor: Colors.deepOrange,
                  ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/create/album');
            },
            heroTag: "create_album",
            child: Icon(Icons.add),
            backgroundColor: Colors.deepOrange,
          ),
        ]));
  }
}
