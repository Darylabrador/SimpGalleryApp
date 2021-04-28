import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('sharePhoto');

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
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://googleflutter.com/sample_image.jpg'),
                    fit: BoxFit.fill
                  ),
                  ),
                ),


                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: OutlinedButton  (
                      onPressed: () => {
                       Navigator.pushNamed(context, '/profil/verify')
                      },
                      style: TextButton.styleFrom(primary: Colors.black),
                      child: new Text('Vérifier son adresse mail'),
                    )
                  ),
                ),

                SizedBox(height: 10.0),

               
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child:   TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Pseudo', 
                        border: OutlineInputBorder()
                    )
                  ),
                ),

                
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child:   TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder()
                    ),
                    obscureText: true,
                  ),
                ),

                
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child:   TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Confirmation mot de passe', 
                        border: OutlineInputBorder()
                    ),
                    obscureText: true,
                  ),
                ),


                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 45.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(primary: Colors.redAccent,),
                          child: Text(
                            'Supprimer mon compte', 
                            style: TextStyle(fontSize: 12)
                          ),
                        )
                      )
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, top: 45.0),
                        child: ElevatedButton(
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                          child: Text('Modifier'),
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
