import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Photos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhotosState();
  }
}

class _PhotosState extends State<Photos> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  String _mainText = 'This is the first assignment!';

  @override
  Widget build(BuildContext context) {
    // token for bearer token
    var token = storage.getItem('SimpGalleryToken');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: const Center(
        child: Text(
          'This is Albums Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
