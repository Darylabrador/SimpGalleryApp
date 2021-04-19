import 'package:flutter/material.dart';

class Shared extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SharedState();
  }
}

class _SharedState extends State<Shared> {
  String _mainText = 'This is the first assignment!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared'),
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
