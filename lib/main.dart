import 'package:flutter/material.dart';
import 'package:client/screens/albums/photos.dart';
import 'package:client/screens/albums/shared.dart';
import 'package:client/screens/auth/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'screens/home/home.dart';
import 'screens/home/share_settings.dart';
import 'screens/auth/login.dart';
import 'screens/auth/registration.dart';
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = new LocalStorage('sharePhoto');

String token = storage.getItem('SimpGalleryToken') ?? "";

void main() async {
  await DotEnv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SimpGallery',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),
          '/register': (context) => Registration(),
          '/home': (context) => Home(title: "Accueil"),
          '/photos': (context) => Photos(),
          '/shared': (context) => Shared(),
          '/shared/settings':(context) => ShareSettings(title: "Options"),
        }
    );
  }
}
