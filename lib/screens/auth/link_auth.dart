import 'package:client/screens/auth/registration.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'registration.dart';
import 'package:localstorage/localstorage.dart';

class LinkAuth extends StatefulWidget {
  @override
  _LinkAuthState createState() => _LinkAuthState();
}

class _LinkAuthState extends State<LinkAuth> {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  bool _toggleLoginPage = true;


  void toggleView() {
    setState(() {
      _toggleLoginPage = !_toggleLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // token for bearer token
    var token = storage.getItem('SimpGalleryToken');

    if (_toggleLoginPage) {
      return Login();
    } else {
      return Registration();
    }
  }
}
