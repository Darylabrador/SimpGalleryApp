import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:image_picker/image_picker.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class DialogDelete extends StatelessWidget {
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var response;
    var url;
    var password = "";
    var passwordConfirm = "";
    var token = storage.getItem('SimpGalleryToken');

    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Voulez-vous vraiment supprimer votre compte ?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Mot de passe', border: OutlineInputBorder()),
                  obscureText: true,
                  initialValue: "",
                  onChanged: (val) => password = val,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Confirmation mot de passe',
                      border: OutlineInputBorder()),
                  obscureText: true,
                  initialValue: "",
                  onChanged: (val) => passwordConfirm = val,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          OutlinedButton(
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.black38),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          OutlinedButton(
            child: Text(
              'Valider',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () async {
              url =
                  Uri.parse("${DotEnv.env['DATABASE_URL']}/api/delete/account");
              response = await http.post(url, body: {
                'password': password,
                'passwordConfirm': passwordConfirm,
              }, headers: {
                "Accept": "application/json",
                "Authorization": "Bearer " + token
              });

              if (response.statusCode == 200) {
                if (response.body == "Compte supprimer") {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/');
                } else {
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
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).restorablePush(_dialogBuilder);
      },
      child: Text('Supprimer mon compte', style: TextStyle(fontSize: 12)),
    );
  }
}

class DialogAvatar extends StatelessWidget {
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var response;
    var url;
    var file;
    var token = storage.getItem('SimpGalleryToken');

    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Avatar'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: OutlinedButton(
                  child: Text(
                    'Selectionner une photo depuis la gallery',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    file = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          OutlinedButton(
            child: Text(
              'Annuler',
              style: TextStyle(color: Colors.black38),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          OutlinedButton(
            child: Text(
              'Valider',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () async {
              url =
                  Uri.parse("${DotEnv.env['DATABASE_URL']}/api/update/avatar");
              var request = http.MultipartRequest(
                'POST',
                url,
              );
              request.headers["authorization"] = "Bearer " + token;
              request.files.add(
                  await http.MultipartFile.fromPath('profilPic', file.path));
              var response = await request.send();
              if (response.statusCode == 200) {
                Navigator.of(context).pop();
              }
              print(response);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).restorablePush(_dialogBuilder);
        },
        child: CircleAvatar(
          radius: 55,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                      'https://googleflutter.com/sample_image.jpg'),
                  fit: BoxFit.fill),
            ),
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}

class _ProfilState extends State<Profil> {
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('sharePhoto');

  var pseudo;
  var password = "";
  var passwordConfirm = "";

  var response;
  var url;

  @override
  Widget build(BuildContext context) {
    // token for bearer
    var token = storage.getItem('SimpGalleryToken');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'deconnexion',
            onPressed: () async {
              url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/deconnexion");
              await http.get(url, headers: {
                "Accept": "application/json",
                "Authorization": "Bearer " + token
              });
              await storage.clear();
              await Navigator.pushNamed(context, '/');
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
                  child: Center(
                      child: OutlinedButton(
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/profil/verify')},
                    style: TextButton.styleFrom(primary: Colors.black),
                    child: new Text('Vérifier son adresse mail'),
                  )),
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
                            child: DialogDelete())),
                    Expanded(
                        child: Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, top: 45.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  url = Uri.parse(
                                      "${DotEnv.env['DATABASE_URL']}/api/update/profil");
                                  response = await http.post(url, body: {
                                    'pseudo': pseudo,
                                    'password': password,
                                    'passwordConfirm': passwordConfirm,
                                  }, headers: {
                                    "Accept": "application/json",
                                    "Authorization": "Bearer " + token
                                  });

                                  if (response.statusCode == 200) {
                                    showToast(
                                      response.body,
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
