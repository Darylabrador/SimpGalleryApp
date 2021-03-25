import 'package:client/screens/auth/registration.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'registration.dart';

class LinkAuth extends StatefulWidget {
  @override
  _LinkAuthState createState() => _LinkAuthState();
}

class _LinkAuthState extends State<LinkAuth> {
  bool _toggleLoginPage = true;

  void toggleView() {
    setState(() {
      _toggleLoginPage = !_toggleLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_toggleLoginPage) {
      return Login(toggleView: toggleView);
    } else {
      return Registration(toggleView: toggleView);
    }
  }
}
