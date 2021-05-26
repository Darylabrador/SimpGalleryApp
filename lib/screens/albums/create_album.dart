import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:image_picker/image_picker.dart';

class CreateAlbum extends StatefulWidget {
  @override
  _CreateAlbumState createState() => _CreateAlbumState();
}

class _CreateAlbumState extends State<CreateAlbum> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  String label = '';
  var _cover;
  var coverPicker;

  var response;
  var url;

  final _formKey = GlobalKey<FormState>();

  Future<void> _updateImage(cover) async {
    setState(() {
      _cover = cover;
    });
  }

  @override
  Widget build(BuildContext context) {
    var token = storage.getItem('SimpGalleryToken');

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
                      _cover != null
                          ? Image.file(_cover, fit: BoxFit.cover)
                          : Image.asset('assets/sample-01.jpg',
                              fit: BoxFit.cover),
                      Center(
                          child: GestureDetector(
                        onTap: () async {
                          coverPicker = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          await _updateImage(coverPicker);
                        },
                        child: Text("Selectionner une image",
                            style: TextStyle(color: Colors.white)),
                      )),
                    ])),
                Center(
                  child: Text('Nouvelle album photo',
                      style: Theme.of(context).textTheme.headline6),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0),
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
                          url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/album/create");
                          var request = http.MultipartRequest('POST', url);
                          request.headers["authorization"] = "Bearer " + token;
                          request.fields['label'] = label;
                          request.files.add(await http.MultipartFile.fromPath('cover', _cover.path));
                          await request.send();
                          Navigator.of(context)..pop()..pop()..pushNamed("/home");
                        },
                        child: Text('Ajouter'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context)..pop()..pop()..pushNamed("/home");
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
