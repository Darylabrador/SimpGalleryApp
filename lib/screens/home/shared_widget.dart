import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class SharedWidget extends StatelessWidget {
  final arrayData;
  SharedWidget({this.arrayData});
  final LocalStorage storage = new LocalStorage('sharePhoto');

  @override
  Widget build(BuildContext context) {
    Future leaveShareAlbum(shareId) {
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
                    'Voulez-vous vraiment quitter cet album ?',
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
                Navigator.of(context)
                  ..pop()
                  ..pop()
                  ..pushNamed('/home');
              },
            ),
            OutlinedButton(
              child: Text(
                'Valider',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                var url = Uri.parse(
                    "${DotEnv.env['DATABASE_URL']}/api/album/share/leave/$shareId");
                var response = await http.get(url, headers: {
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
            'Partager avec moi',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          height: 250,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: arrayData.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/shared',
                        arguments: arrayData[index]);
                  },
                  onLongPress: () {
                    leaveShareAlbum(arrayData[index]["id"].toString());
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                            "${DotEnv.env['DATABASE_URL']}/img/" +
                                arrayData[index]['album']['cover'],
                            height: 150,
                            width: 150,
                            fit: BoxFit.fill),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text(
                            arrayData[index]['album']["label"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(arrayData[index]['album']["counterPhoto"]
                                .toString() +
                            " photos")
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
