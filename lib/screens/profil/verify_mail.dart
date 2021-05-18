import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class VerifyMail extends StatefulWidget {
  @override
  _VerifyMailState createState() => _VerifyMailState();
}

class _VerifyMailState extends State<VerifyMail> {
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('sharePhoto');

  var response;
  var url;
  String validationCode = '';

  @override
  Widget build(BuildContext context) {
    // token for bearer
    var token = storage.getItem('SimpGalleryToken');
    var avatar = storage.getItem('SimpGalleryAvatar');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
         actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'deconnexion',
            onPressed: () async {
              url = Uri.parse(
                  "${DotEnv.env['DATABASE_URL']}/api/deconnexion");
              await http.get(url,
                  headers: {
                    "Accept": "application/json",
                    "Authorization" : "Bearer " + token
                  });
              await storage.clear();
              await Navigator.pushNamed(context, '/logging');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: GestureDetector(
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
                ),
                Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Center(
                        child: Text('Vérification adresse mail',
                            style: Theme.of(context).textTheme.button))),
                Container(
                  margin: const EdgeInsets.only(top: 60.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Saisir le jeton de vérification',
                        border: OutlineInputBorder()),
                    validator: (val) =>
                        val!.isEmpty ? 'Saisir le code de validation' : null,
                    onChanged: (val) => validationCode = val,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                            margin:
                                const EdgeInsets.only(right: 20.0, top: 165.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent),
                              child: Text('Annuler'),
                            ))),
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 165.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  url = Uri.parse(
                                      "${DotEnv.env['DATABASE_URL']}/api/email/verification");
                                  response = await http.post(url,
                                      body: {'verifyToken': validationCode},
                                      headers: {
                                        "Accept": "application/json",
                                        "Authorization" : "Bearer " + token
                                      });

                                  if (response.statusCode == 200) {
                                    var parsedJson = json.decode(response.body);
                                    if(parsedJson['success']) {
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
                                      storage.setItem("SimpGalleryMailVerify", false);
                                      Navigator.of(context)..pop()..pop()..pushNamed('/profil');
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
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent),
                              child: Text('Valider'),
                            )
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
