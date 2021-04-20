import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class AskForgottenPwd extends StatefulWidget {
  @override
  _AskForgottenPwdState createState() => _AskForgottenPwdState();
}

class _AskForgottenPwdState extends State<AskForgottenPwd> {
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('sharePhoto');
  var response;
  var url;

  String email = '';

  @override
  Widget build(BuildContext context) {
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
                    child: Text('Réinitialisation',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ),
                
                SizedBox(height: 10.0),

                Container(
                  margin: const EdgeInsets.only(top: 25.0),
                  child:  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Adresse mail',
                        border: OutlineInputBorder()),
                    validator: (val) => val!.isEmpty ? 'Entrez une adresse mail' : null,
                    onChanged: (val) => email = val,
                  ),
                ),

                SizedBox(height: 10.0),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0, top: 10.0),
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
                        margin: const EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {

                              url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/reset/request");
                              response = await http.post(url, body: {
                                'identifiant': email,
                              }, headers: {
                                "Accept": "application/json"
                              });

                              if (response.statusCode == 200) {
                                storage.setItem("resetCode", response.body);
                                Navigator.pushNamed(context, '/forgotten/confirm');
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
