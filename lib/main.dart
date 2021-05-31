import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:localstorage/localstorage.dart';

import './route_generator.dart';

void main() async {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  await DotEnv.load();
  storage.ready.then((_) => {
        runApp(MaterialApp(
          title: 'SimpGallery',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          initialRoute: storage.getItem("SimpGalleryToken") == null
              ? '/logging'
              : '/home',
          onGenerateRoute: RouteGenerator.generateRoute,
        ))
      });
}
