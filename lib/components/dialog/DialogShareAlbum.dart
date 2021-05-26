import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class DialogShareAlbum extends StatefulWidget {
  final allData;
  DialogShareAlbum({this.allData});

  @override
  _DialogShareAlbum createState() => _DialogShareAlbum();
}

class _DialogShareAlbum extends State<DialogShareAlbum> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  final _formKey = GlobalKey<FormState>();

  String target = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    var token = storage.getItem('SimpGalleryToken');

    Future renderDialog() {
      return showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Partager l'album", textAlign: TextAlign.center),
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
                              labelText: "Adresse email",
                              border: OutlineInputBorder()),
                          validator: (val) =>
                              val!.isEmpty ? 'Entrez un email' : null,
                          onChanged: (val) => target = val,
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Votre message personnalisé",
                              border: OutlineInputBorder()),
                          onChanged: (val) => message = val,
                        ),
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
                setState(() {
                  message = "";
                  target = "";
                });
                Navigator.of(context).pop();
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
                      "${DotEnv.env['DATABASE_URL']}/api/album/share");
                  var response = await http.post(url, body: {
                    'target': target,
                    'message': message,
                    'albumId': widget.allData["id"].toString(),
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

                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pushNamed('/photos', arguments: widget.allData);
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

    return FloatingActionButton(
      onPressed: () => renderDialog(),
      heroTag: 'share',
      child: Icon(Icons.share),
      backgroundColor: Colors.deepOrange,
    );
  }
}
