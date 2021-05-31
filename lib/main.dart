import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './route_generator.dart';

// @dart=2.9
void main() async {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  await DotEnv.load();
  SharedPreferences.getInstance().then((value) => {
      storage.ready.then((_) => {
        runApp(MaterialApp(
          title: 'SimpGallery',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          initialRoute: value.getString("tok") == null
              ? '/logging'
              : '/home',
          onGenerateRoute: RouteGenerator.generateRoute,
        ))
      })
  });
}
