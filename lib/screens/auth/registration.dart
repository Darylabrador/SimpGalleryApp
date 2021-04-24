import 'package:flutter/material.dart';
import 'package:client/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late Future<User> futureAlbum;
  final LocalStorage storage = new LocalStorage('sharePhoto');

  String email = '';
  String password = '';
  String confirmPassword = '';

  var response;
  var url;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

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
                  child: Text('Inscrivez-vous',
                      style: Theme.of(context).textTheme.headline6),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
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
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Confirmez le mot de passe',
                      border: OutlineInputBorder()),
                  onChanged: (val) => confirmPassword = val,
                  validator: (val) => confirmPassword != password
                      ? 'Le mot de passe ne correspond pas'
                      : null,
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      url = Uri.parse(
                          // "${DotEnv.env['DATABASE_URL']}/api/inscription");
                          "http://2c591573402e.ngrok.io/api/inscription");
                      // "http://315d7f58ac18.ngrok.io/api/inscription");

                      response = await http.post(url, body: {
                        'identifiant': email,
                        'password': password,
                        'passwordConfirm': confirmPassword
                      }, headers: {
                        "Accept": "application/json"
                      });
                      if (response.statusCode == 200) {
                        // If the server did return a 200 OK response,
                        // then parse the JSON.
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
                        Navigator.pushNamed(context, '/');
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
                  child: Text('Inscription'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text("J'ai déjà un compte"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
