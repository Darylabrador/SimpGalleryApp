import 'package:client/screens/auth/login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'screens/home/home.dart';
import 'screens/auth/login.dart';
import 'screens/auth/registration.dart';

void main() async {
  runApp(MyApp());
  // await DotEnv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
        initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/register': (context) => Registration(),
        '/home': (context) => Home(title: "Accueil"),
      }
      // home: Registration(
      //   toggleView: () => {false},
      // ),
      //
    );
  }
}
