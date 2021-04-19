import 'package:flutter/material.dart';
import 'package:client/models/user.dart';

import 'dart:async';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late Future<User> futureAlbum;

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
                          'http://7aa624de6429.ngrok.io/api/inscription');
                      response = await http.post(url, body: {
                        'identifiant': email,
                        'password': password,
                        'passwordConfirm': confirmPassword
                      });

                      print('Response status: ${response.statusCode}');
                      // print('Response body: ${response.body}');
                      // print(await http.read(url));

                      print('registration : .... pls');

                      if (response.statusCode == 200) {
                        // If the server did return a 200 OK response,
                        // then parse the JSON.
                        print(response.body);
                        Navigator.pushNamed(context, '/');
                      } else {
                        print('error boi');
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
