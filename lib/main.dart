import 'package:flutter/material.dart';
import 'package:client/screens/albums/photos.dart';
import 'package:client/screens/albums/shared.dart';
import 'package:client/screens/auth/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'screens/home/home.dart';
import 'screens/home/share_settings.dart';
import 'screens/auth/login.dart';
import 'screens/auth/registration.dart';
import 'screens/auth/ask_forgotten_pwd.dart';
import 'screens/auth/reset_forgotten_pwd.dart';
import 'screens/profil/verify_mail.dart';
import 'screens/albums/create_album.dart';
import 'package:localstorage/localstorage.dart';

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
          '/create/album': (context) => CreateAlbum(),
          '/home': (context) => Home(title: "Accueil"),
          '/photos': (context) => Photos(),
          '/shared': (context) => Shared(),
          '/shared/settings':(context) => ShareSettings(title: "Options"),
          '/verify/mail': (context) => VerifyMail(),
          '/forgotten/ask': (context) => AskForgottenPwd(),
          '/forgotten/confirm': (context) => ResetForgottenPwd(),
        }
    );
  }
}
