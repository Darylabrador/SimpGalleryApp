import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';


class DialogDeleteAccount extends StatelessWidget {
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var response;
    var url;
    var password = "";
    var passwordConfirm = "";
    var token = storage.getItem('SimpGalleryToken');

    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Voulez-vous vraiment supprimer votre compte ?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Mot de passe', border: OutlineInputBorder()),
                  obscureText: true,
                  initialValue: "",
                  onChanged: (val) => password = val,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Confirmation mot de passe',
                      border: OutlineInputBorder()),
                  obscureText: true,
                  initialValue: "",
                  onChanged: (val) => passwordConfirm = val,
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
                  Uri.parse("${DotEnv.env['DATABASE_URL']}/api/delete/account");
              response = await http.post(url, body: {
                'password': password,
                'passwordConfirm': passwordConfirm,
              }, headers: {
                "Accept": "application/json",
                "Authorization": "Bearer " + token
              });

              if (response.statusCode == 200) {
                var parsedJson = json.decode(response.body);

                if (parsedJson['success']) {
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
                  storage.clear();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/');
                } else {
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
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).restorablePush(_dialogBuilder);
      },
      child: Text('Supprimer mon compte', style: TextStyle(fontSize: 12)),
    );
  }
}