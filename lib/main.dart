import 'package:flutter/material.dart';

import 'package:minaret/about.dart';
import 'package:minaret/home.dart';
import 'package:minaret/zone.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minaret',
      theme: ThemeData(
        fontFamily: 'Varela',
      ),
      initialRoute: '/home',
      routes: {
        '/home': (_) => HomePage(),
        '/about': (_) => AboutPage(),
        '/zone': (_) => ZonePage(),
      },
    );
  }
}
