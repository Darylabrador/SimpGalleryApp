import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class Shared extends StatefulWidget {
  final arrayData;
  Shared({this.arrayData});

  @override
  State<StatefulWidget> createState() {
    return _SharedState();
  }
}

class _SharedState extends State<Shared> {
  final LocalStorage storage = new LocalStorage('sharePhoto');

  @override
  Widget build(BuildContext context) {
    // token for bearer token
    var token = storage.getItem('SimpGalleryToken');
    var url;
    print(widget.arrayData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'deconnexion',
            onPressed: () async {
              url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/deconnexion");
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
                    Image.network(
                        "${DotEnv.env['DATABASE_URL']}/img/" +
                            widget.arrayData['cover'],
                        height: 200,
                        width: 500,
                        fit: BoxFit.fill)
                  ])
              ),
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
                      ]
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
