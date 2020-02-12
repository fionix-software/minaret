import 'package:flutter/material.dart';

import 'package:waktuku/about.dart';
import 'package:waktuku/home.dart';
import 'package:waktuku/check.dart';
import 'package:waktuku/zone.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Varela',
      ),
      initialRoute: '/check',
      routes: {
        '/about': (_) => AboutPage(),
        '/home': (_) => HomePage(),
        '/check': (_) => CheckingPage(),
        '/zone': (_) => ZonePage(firstTime: false),
        '/zone/first-time': (_) => ZonePage(firstTime: true),
      },
    );
  }
}
