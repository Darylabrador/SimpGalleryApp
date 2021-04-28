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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://googleflutter.com/sample_image.jpg'),
                        fit: BoxFit.fill),
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
                                    Navigator.pop(context);
                                    showToast(
                                      response.body,
                                      context: context,
                                      animation: StyledToastAnimation.scale,
                                      reverseAnimation: StyledToastAnimation.fade,
                                      position: StyledToastPosition.bottom,
                                      animDuration: Duration(seconds: 1),
                                      duration: Duration(seconds: 4),
                                      curve: Curves.elasticOut,
                                      reverseCurve: Curves.linear,
                                    );
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
                            ))),
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
