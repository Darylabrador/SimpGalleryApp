import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Shared extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SharedState();
  }
}

class _SharedState extends State<Shared> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  String _mainText = 'This is the first assignment!';

  @override
  Widget build(BuildContext context) {
    // token for bearer token
    var token = storage.getItem('SimpGalleryToken');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared'),
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
      body: const Center(
        child: Text(
          'This is Shared Photos Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
