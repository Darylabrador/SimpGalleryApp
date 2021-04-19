import 'package:flutter/material.dart';

class Photos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PhotosState();
  }
}

class _PhotosState extends State<Photos> {
  String _mainText = 'This is the first assignment!';

  @override
  Widget build(BuildContext context) {
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
