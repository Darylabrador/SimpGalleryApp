import 'package:flutter/material.dart';
import '../home/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class CreateAlbum extends StatefulWidget {
  @override
  _CreateAlbumState createState() => _CreateAlbumState();
}

class _CreateAlbumState extends State<CreateAlbum> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  String label = '';
  String cover = '';

  var response;
  var url;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                    height: 300,
                    width: 500,
                    child: Stack(children: <Widget>[
                      Image.asset('assets/sample-01.jpg', fit: BoxFit.cover),
                      Center(
                        child: OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.lightBlue),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
                          },
                          child: Text("Selectionner une image"),
                        ),
                      ),
                    ])),
                SizedBox(height: 50.0),
                Center(
                  child: Text('Ajouter un album',
                      style: Theme.of(context).textTheme.headline6),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Nom de l\'album',
                            border: OutlineInputBorder()),
                        validator: (val) => val!.isEmpty
                            ? 'Entrez un nom pour votre album'
                            : null,
                        onChanged: (val) => label = val,
                      ),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () async {
                          // if (_formKey.currentState!.validate()) {
                          //   url = Uri.parse(
                          //       // "${DotEnv.env['DATABASE_URL']}/api/connexion");
                          //       "http://78c7949cddff.ngrok.io/api/inscription");
                          //   response = await http.post(url, body: {
                          //     'identifiant': email,
                          //     'password': password,
                          //   }, headers: {
                          //     "Accept": "application/json"
                          //   });

                          //   if (response.statusCode == 200) {
                          //     storage.setItem("SimpGalleryToken", response.body);
                          //     Navigator.pushNamed(context, '/home');
                          //   } else {
                          //     showToast(
                          //       "Une erreur est survenue",
                          //       context: context,
                          //       animation: StyledToastAnimation.scale,
                          //       reverseAnimation: StyledToastAnimation.fade,
                          //       position: StyledToastPosition.bottom,
                          //       animDuration: Duration(seconds: 1),
                          //       duration: Duration(seconds: 4),
                          //       curve: Curves.elasticOut,
                          //       reverseCurve: Curves.linear,
                          //     );
                          //   }
                          // }
                        },
                        child: Text('Ajouter'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Text("Annuler"),
                      ),
                    ],
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
