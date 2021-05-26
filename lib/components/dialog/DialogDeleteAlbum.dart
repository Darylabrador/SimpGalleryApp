import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class DialogDeleteAlbum extends StatefulWidget {

  @override
  _DialogDeleteAlbum createState() => _DialogDeleteAlbum();
}

class _DialogDeleteAlbum extends State<DialogDeleteAlbum> {
  final LocalStorage storage = new LocalStorage('sharePhoto');

  @override
  Widget build(BuildContext context) {
    var token = storage.getItem('SimpGalleryToken');

    Future renderDialog() {
      return showDialog<String>(
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

              },
            ),
          ],
        ),
      );
    }

    return FloatingActionButton(
      onPressed: () => renderDialog(),
      child: Icon(Icons.add),
      backgroundColor: Colors.deepOrange,
    );
  }
}
