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

Future<Album> fetchAlbum() async {
  final response =
      await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("ok ok");
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Album> futureAlbum;
  final LocalStorage storage = new LocalStorage('sharePhoto');

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
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
          Container(child: AlbumsWidget()),
          Container(child: SharedWidget()),
          Container(
            child: Center(
              child: FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.label);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ]),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget> [
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
        ]
      )
    );
  }
}
