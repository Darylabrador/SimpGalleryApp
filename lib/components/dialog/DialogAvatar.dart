import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:image_picker/image_picker.dart';


class DialogAvatar extends StatelessWidget {
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var url;
    var file;
    var token = storage.getItem('SimpGalleryToken');

    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Avatar', textAlign: TextAlign.center),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: OutlinedButton(
                  child: Text(
                    'Selectionner une photo depuis la gallery',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    file = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                  },
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
              url =
                  Uri.parse("${DotEnv.env['DATABASE_URL']}/api/update/avatar");
              var request = http.MultipartRequest(
                'POST',
                url,
              );
              request.headers["authorization"] = "Bearer " + token;
              request.files.add(
                  await http.MultipartFile.fromPath('profilPic', file.path));
              await request.send();
              Navigator.of(context)..pop()..pop()..pushNamed('/profil');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var avatar = storage.getItem('SimpGalleryAvatar');

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).restorablePush(_dialogBuilder);
        },
        child: CircleAvatar(
          radius: 55,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image:
                      NetworkImage("${DotEnv.env['DATABASE_URL']}/img/$avatar"),
                  fit: BoxFit.fill),
            ),
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}