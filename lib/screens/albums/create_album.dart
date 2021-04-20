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
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset('assets/sample-01.jpg',
                    height: 100.0, width: 100.0),
                Center(
                  child: Text('Ajouter un album',
                      style: Theme.of(context).textTheme.headline6),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Label', border: OutlineInputBorder()),
                  validator: (val) =>
                      val!.isEmpty ? 'Entrez un nom pour votre album' : null,
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
                  child: Text('Créer'),
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
        ),
      ),
    );
  }
}
