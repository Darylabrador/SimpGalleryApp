import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class VerifyMail extends StatefulWidget {
  @override
  _VerifyMailState createState() => _VerifyMailState();
}

class _VerifyMailState extends State<VerifyMail> {
  final _formKey = GlobalKey<FormState>();
  var response;
  var url;

  String validationCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification adresse mail'),
      ),
      body: Center(child: Text('You have pressed the button times.')),
    );
  }
}
