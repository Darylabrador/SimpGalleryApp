import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class ResetForgottenPwd extends StatefulWidget {
  @override
  _ResetForgottenPwdState createState() => _ResetForgottenPwdState();
}

class _ResetForgottenPwdState extends State<ResetForgottenPwd> {
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('sharePhoto');
  var response;
  var url;

  String password = '';
  String passwordConfirm = '';

  @override
  Widget build(BuildContext context) {
    var validationCode = storage.getItem('resetCode');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset('assets/sample-01.jpg',
                    height: 100.0, width: 100.0
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Text('Réinitialisation du mot de passe',
                      style: Theme.of(context).textTheme.headline6
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Nouveau mot de passe',
                        border: OutlineInputBorder()),
                    validator: (val) => val!.isEmpty ? 'Entrez votre nouveau mot de passe' : null,
                    onChanged: (val) => password = val,
                    obscureText: true,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Confirmation mot de passe',
                        border: OutlineInputBorder()
                    ),
                    validator: (val) => val!.isEmpty ? 'Confirmez votre mot de passe' : null,
                    onChanged: (val) => passwordConfirm = val,
                    obscureText: true,
                  ),
                ),

                SizedBox(height: 10.0),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0, top: 15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/');
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
                          child: Text('Annuler'),
                        )
                      )
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 15.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/reset/password");
                              response = await http.post(url, body: {
                                'resetToken': validationCode,
                                'password': password,
                                'passwordConfirm': passwordConfirm,
                              }, headers: {
                                "Accept": "application/json"
                              });

                              if (response.statusCode == 200) {
                                storage.clear();
                                Navigator.pushNamed(context, '/');
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
