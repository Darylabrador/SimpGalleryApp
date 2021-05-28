import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:image_picker/image_picker.dart';

class DialogImage extends StatefulWidget {
  final albumId;
  final isShare;
  final allData;
  DialogImage({this.albumId, this.allData, this.isShare});

  @override
  _DialogImage createState() => _DialogImage();
}

class _DialogImage extends State<DialogImage> {
  final LocalStorage storage = new LocalStorage('sharePhoto');

  @override
  Widget build(BuildContext context) {
    var token = storage.getItem('SimpGalleryToken');
    var _file;
    var filePicker;

    Future<void> _updatePicker(file) async {
      Navigator.of(context).pop();
      setState(() {
        _file = file;
      });
    }

    Future renderDialog() {
      return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Ajouter une photo", textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: OutlinedButton(
                    child: Text(
                      'Selectionner une image',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      filePicker = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      await _updatePicker(filePicker);
                      await renderDialog();
                    },
                  ),
                ),
                Container(
                  height: _file != null ? 100 : null,
                  child: _file != null
                      ? Image.file(_file, fit: BoxFit.cover)
                      : null,
                )
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
                'Enregistrer',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                var url =
                    Uri.parse("${DotEnv.env['DATABASE_URL']}/api/photo/create");
                var request = http.MultipartRequest('POST', url);
                request.headers["authorization"] = "Bearer " + token;
                request.fields['albumId'] = widget.albumId.toString();
                request.files.add(
                    await http.MultipartFile.fromPath('image', _file.path));
                await request.send();
                if (widget.isShare) {
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pushNamed('/shared', arguments: widget.allData);
                } else {
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pushNamed('/photos', arguments: widget.allData);
                }
              },
            ),
          ],
        ),
      );
    }

    return FloatingActionButton(
      onPressed: () => renderDialog(),
      child: Icon(Icons.add),
      backgroundColor: Colors.deepOrange,
    );
  }
}
