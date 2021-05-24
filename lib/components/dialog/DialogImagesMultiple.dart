import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:image_picker/image_picker.dart';

class DialogImagesMultiple extends StatelessWidget {
  final isShare;
  DialogImagesMultiple({this.isShare});

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');

    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Contenue de l'album"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: OutlinedButton(
                  child: Text(
                    'Selectionner des images',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {},
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
            onPressed: () async {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).restorablePush(_dialogBuilder);
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.deepOrange,
    );
  }
}
