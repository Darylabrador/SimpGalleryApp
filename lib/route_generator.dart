import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:simpgalleryapp/screens/albums/albumTrash.dart';
import 'package:simpgalleryapp/screens/albums/photoTrash.dart';
import 'main.dart';

import 'package:simpgalleryapp/screens/albums/photos.dart';
import 'package:simpgalleryapp/screens/albums/shared.dart';
import 'package:simpgalleryapp/screens/auth/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'screens/home/home.dart';
import 'screens/auth/login.dart';
import 'screens/auth/registration.dart';
import 'screens/auth/ask_forgotten_pwd.dart';
import 'screens/auth/reset_forgotten_pwd.dart';
import 'screens/profil/verify_mail.dart';
import 'screens/albums/create_album.dart';
import 'screens/profil/profil.dart';
import 'screens/profil/verify_mail.dart';
import 'package:localstorage/localstorage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    final LocalStorage storage = new LocalStorage('sharePhoto');

    switch (settings.name) {
      case '/logging':
        return MaterialPageRoute(builder: (_) => Login());
      case '/register':
        return MaterialPageRoute(builder: (_) => Registration());
      case '/create/album':
        return MaterialPageRoute(builder: (_) => CreateAlbum());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home(title: "Accueil"));
      case '/photos':
        if (args != null) {
          return MaterialPageRoute(builder: (_) => Photos(arrayData: args));
        } else {
          return MaterialPageRoute(builder: (_) => ErrorPage());
        }
      case '/shared':
        if (args != null) {
          return MaterialPageRoute(builder: (_) => Shared(arrayData: args));
        } else {
          return MaterialPageRoute(builder: (_) => ErrorPage());
        }
      case '/verify/mail':
        return MaterialPageRoute(builder: (_) => VerifyMail());
      case '/forgotten/ask':
        return MaterialPageRoute(builder: (_) => AskForgottenPwd());
      case '/forgotten/confirm':
        return MaterialPageRoute(builder: (_) => ResetForgottenPwd());
      case '/profil':
        return MaterialPageRoute(builder: (_) => Profil());
      case '/profil/verify':
        return MaterialPageRoute(builder: (_) => VerifyMail());
      case '/trash/photos':
        if (args != null) {
          return MaterialPageRoute(builder: (_) => PhotoTrash(argsData: args));
        } else {
          return MaterialPageRoute(builder: (_) => ErrorPage());
        }
      case '/trash/albums':
        return MaterialPageRoute(builder: (_) => AlbumTrash());
      default:
        return storage.getItem("SimpGalleryToken") == null
            ? MaterialPageRoute(builder: (_) => Login())
            : MaterialPageRoute(builder: (_) => Home(title: "Accueil"));
    }
  }
}

class ErrorPage extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('sharePhoto');
  @override
  Widget build(BuildContext context) {
    // token for bearer token
    var token = storage.getItem('SimpGalleryToken');
    var url;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context)
            ..pop()
            ..pop()
            ..pushNamed('/home'),
        ),
        title: const Text('Albums'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'deconnexion',
            onPressed: () async {
              url = Uri.parse("${DotEnv.env['DATABASE_URL']}/api/deconnexion");
              await http.get(url, headers: {
                "Accept": "application/json",
                "Authorization": "Bearer " + token
              });
              await storage.clear();
              await Navigator.pushNamed(context, '/logging');
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text("La page chercher n'existe pas"),
        ),
      ),
    );
  }
}
