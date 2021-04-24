import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  String email = '';
  String password = '';

  var response;
  var url;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset('assets/sample-01.jpg',
                    height: 100.0, width: 100.0),
                Center(
                  child: Text('Connexion',
                      style: Theme.of(context).textTheme.headline6),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email / N° téléphone',
                      border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Entrez un email' : null,
                  onChanged: (val) => email = val,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Mot de passe', border: OutlineInputBorder()),
                  validator: (val) => val!.length < 6
                      ? 'Entrez un mot de passe avec 6 ou plus'
                          'des caracteres'
                      : null,
                  onChanged: (val) => password = val,
                  obscureText: true,
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      url = Uri.parse(
                          // "${DotEnv.env['DATABASE_URL']}/api/connexion");
                          "http://2c591573402e.ngrok.io/api/connexion");
                      // "http://315d7f58ac18.ngrok.io/api/connexion");
                      response = await http.post(url, body: {
                        'identifiant': email,
                        'password': password,
                      }, headers: {
                        "Accept": "application/json"
                      });

                      if (response.statusCode == 200) {
                        storage.setItem("SimpGalleryToken", response.body);
                        Navigator.pushNamed(context, '/home');
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
                  child: Text('Connexion'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text("Je n'ai pas de compte"),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 100.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotten/ask');
                    },
                    child: Text(
                      "Mot de passe oublié ?",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
