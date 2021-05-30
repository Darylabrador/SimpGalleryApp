import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class DialogSettingShare extends StatefulWidget {
  final albumId;
  DialogSettingShare({this.albumId});

  @override
  _DialogSettingShare createState() => _DialogSettingShare();
}

class _DialogSettingShare extends State<DialogSettingShare> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  List<dynamic> _participantList = [];
  var deleteList = [];
  String target = '';
  String message = '';

  @override
  void initState() {
    super.initState();
    fetchParticipants();
  }

  Future fetchParticipants() async {
    final LocalStorage storage = new LocalStorage('sharePhoto');
    var token = storage.getItem('SimpGalleryToken');
    var id = widget.albumId.toString();

    var url =
        Uri.parse("${DotEnv.env['DATABASE_URL']}/api/album/$id/participants");
    var getAlbums = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    });

    if (getAlbums.statusCode == 200) {
      var parsedJson = json.decode(getAlbums.body);
      setState(() {
        _participantList = parsedJson['data'];
      });
      print(parsedJson);
    }
  }

  @override
  Widget build(BuildContext context) {
    var token = storage.getItem('SimpGalleryToken');

    Future renderDialog() {
      return showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Participants", textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    height: _participantList.length != 0 ? 150 : null,
                    margin: const EdgeInsets.only(top: 5.0),
                    child: _participantList.length != 0
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8),
                            itemCount: _participantList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _participantList[index]["selected"] =
                                            !_participantList[index]
                                                ["selected"];
                                      });
                                      Navigator.of(context).pop();
                                      renderDialog();

                                      if (_participantList[index]["selected"]
                                              .toString() ==
                                          "true") {
                                        deleteList.add(_participantList[index]
                                                ["participant"]["id"]
                                            .toString());
                                      } else {
                                        var deleteIndex = deleteList.indexOf(
                                            _participantList[index]
                                                    ["participant"]["id"]
                                                .toString());
                                        deleteList.removeAt(deleteIndex);
                                      }
                                      print(_participantList[index]
                                          ["participant"]["id"]);
                                      print(deleteList);
                                    },
                                    child: Container(
                                        child: _participantList[index]
                                                        ["selected"]
                                                    .toString() ==
                                                "true"
                                            ? Row(children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        right: 5.0),
                                                    child: Icon(
                                                      Icons.check_circle,
                                                      color: Colors.deepOrange,
                                                    )),
                                                Text(_participantList[index]
                                                            ["participant"]
                                                        ["pseudo"]
                                                    .toString())
                                              ])
                                            : Row(children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        right: 5.0),
                                                    child: Icon(
                                                      Icons.circle,
                                                      color: Colors.deepOrange,
                                                    )),
                                                Text(_participantList[index]
                                                            ["participant"]
                                                        ["pseudo"]
                                                    .toString())
                                              ]))),
                              );
                            })
                        : Text("")),
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
              onPressed: () async {},
            ),
          ],
        ),
      );
    }

    return FloatingActionButton(
      onPressed: () async => {
        renderDialog(),
      },
      heroTag: 'setting',
      child: Icon(Icons.settings),
      backgroundColor: Colors.deepOrange,
    );
  }
}
