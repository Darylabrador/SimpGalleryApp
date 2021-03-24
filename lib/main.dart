import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/material.dart';
import 'screens/home/home.dart';

void main() async {
  runApp(MyApp());
  await DotEnv.load(fileName: ".env");
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
      home: Home(title: 'SimpGalleryApp'),
    );
  }
}
