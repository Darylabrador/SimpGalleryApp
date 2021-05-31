import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/dialog/DialogAvatar.dart';
import '../../components/dialog/DialogDeleteAccount.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('sharePhoto');

  var password = "";
  var passwordConfirm = "";

  var response;
  var url;

  Future<void> getAvatar() async {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');
    var newUrl = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/account/info");
    var newResponse = await http.get(newUrl, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    });

    if (newResponse.statusCode == 200) {
      var parsedJson = json.decode(newResponse.body);
      storage.setItem("SimpGalleryAvatar", parsedJson['data']['avatar']);
    }
  }

  @override
  Widget build(BuildContext context) {
    // token for bearer
    var token = storage.getItem('SimpGalleryToken');
    var pseudo = storage.getItem('SimpGalleryPseudo');
    var identite = storage.getItem('SimpGalleryIdentity');
    var verify = storage.getItem('SimpGalleryMailVerify');
    getAvatar();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context)
            ..pop()
            ..pop()
            ..pushNamed('/home'),
        ),
        title: const Text('Mon profil'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'deconnexion',
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("tok");
              url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/deconnexion");
              await http.get(url, headers: {
                "Accept": "application/json",
                "Authorization": "Bearer " + token
              });
              await storage.clear();
              await Navigator.pushNamed(context, '/logging');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DialogAvatar(),
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: verify
                      ? Center(
                          child: OutlinedButton(
                          onPressed: () =>
                              {Navigator.pushNamed(context, '/profil/verify')},
                          style: TextButton.styleFrom(primary: Colors.black),
                          child: new Text('Vérifier son adresse mail'),
                        ))
                      : null,
                ),
                SizedBox(height: 10.0),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Pseudo', border: OutlineInputBorder()),
                    validator: (val) =>
                        val!.isEmpty ? 'Saisir un pseudo' : null,
                    onChanged: (val) => pseudo = val,
                    initialValue: pseudo,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Adresse mail',
                        border: OutlineInputBorder()),
                    validator: (val) =>
                        val!.isEmpty ? 'Adresse mail obligatoire' : null,
                    onChanged: (val) => identite = val,
                    initialValue: identite,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder()),
                    obscureText: true,
                    initialValue: "",
                    onChanged: (val) => password = val,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Confirmation mot de passe',
                        border: OutlineInputBorder()),
                    obscureText: true,
                    initialValue: "",
                    onChanged: (val) => passwordConfirm = val,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 45.0),
                            child: DialogDeleteAccount())),
                    Expanded(
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, top: 45.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  url = Uri.parse(
                                      "${DotEnv.env['DATABASE_URL']}/api/update/profil");
                                  response = await http.post(url,
                                      body: json.encode({
                                        'identite': identite,
                                        'pseudo': pseudo,
                                        'password': password,
                                        'passwordConfirm': passwordConfirm,
                                      }),
                                      headers: {
                                        "Content-Type": "application/json",
                                        "Accept": "application/json",
                                        "Authorization": "Bearer " + token
                                      });

                                  if (response.statusCode == 200) {
                                    var parsedJson = json.decode(response.body);
                                    showToast(
                                      parsedJson['message'],
                                      context: context,
                                      animation: StyledToastAnimation.scale,
                                      reverseAnimation:
                                          StyledToastAnimation.fade,
                                      position: StyledToastPosition.bottom,
                                      animDuration: Duration(seconds: 1),
                                      duration: Duration(seconds: 4),
                                      curve: Curves.elasticOut,
                                      reverseCurve: Curves.linear,
                                    );

                                    if (parsedJson['success']) {
                                      storage.setItem("SimpGalleryPseudo",
                                          parsedJson['pseudo']);
                                      storage.setItem("SimGalleryIdentity",
                                          parsedJson['info']);
                                    }
                                  } else {
                                    showToast(
                                      "Une erreur est survenue",
                                      context: context,
                                      animation: StyledToastAnimation.scale,
                                      reverseAnimation:
                                          StyledToastAnimation.fade,
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
                              child: Text('Modifier'),
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
