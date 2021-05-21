import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:localstorage/localstorage.dart';

import './route_generator.dart';

void main() async {
  await DotEnv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final LocalStorage storage = new LocalStorage('sharePhoto');
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'SimpGallery',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        initialRoute: '/logging',
        onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
