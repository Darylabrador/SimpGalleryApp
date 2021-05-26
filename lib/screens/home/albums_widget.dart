import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import '../../screens/albums/photos.dart';

class AlbumsWidget extends StatelessWidget {
  final arrayData;
  AlbumsWidget({this.arrayData});
  final LocalStorage storage = new LocalStorage('sharePhoto');

  @override
  Widget build(BuildContext context) {
    Future deleteSingleAlbumDialog(albumId) {
      var token = storage.getItem('SimpGalleryToken');

      return showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'Voulez-vous vraiment supprimer cet album ?',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
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
                var url = Uri.parse(
                    "${DotEnv.env['DATABASE_URL']}/api/album/delete/$albumId");
                var response = await http.delete(url, headers: {
                  "Accept": "application/json",
                  "Authorization": "Bearer " + token
                });
                if (response.statusCode == 200) {
                  var parsedJson = json.decode(response.body);

                  showToast(
                    parsedJson['message'],
                    context: context,
                    animation: StyledToastAnimation.scale,
                    reverseAnimation: StyledToastAnimation.fade,
                    position: StyledToastPosition.bottom,
                    animDuration: Duration(seconds: 1),
                    duration: Duration(seconds: 4),
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.linear,
                  );

                  if (parsedJson['success']) {
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pushNamed('/home');
                  }
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
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Mes Albums',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: arrayData.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/photos',
                        arguments: arrayData[index]);
                  },
                  onLongPress: () {
                    deleteSingleAlbumDialog(arrayData[index]["id"].toString());
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                            "${DotEnv.env['DATABASE_URL']}/img/" +
                                arrayData[index]['cover'],
                            height: 150,
                            width: 150,
                            fit: BoxFit.fill),
                        Text(
                          arrayData[index]["label"],
                        ),
                      ],
                    ),
                  ),
                ));
              }),
        )
      ],
    );
  }
}
