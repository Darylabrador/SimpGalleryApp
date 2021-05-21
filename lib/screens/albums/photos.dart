import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class Photos extends StatefulWidget {
  final arrayData;
  Photos({this.arrayData});

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
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
      body: const Center(
        child: Text(
          '$widget.arrayData["label"]',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
