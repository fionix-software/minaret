import 'package:flutter/material.dart';

import 'package:minaret/about.dart';
import 'package:minaret/home.dart';
import 'package:minaret/check.dart';
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
      initialRoute: '/check',
      routes: {
        '/about': (_) => AboutPage(),
        '/home': (_) => HomePage(),
        '/check': (_) => CheckingPage(),
        '/zone': (_) => ZonePage(isFirstTime: false),
        '/zone/first-time': (_) => ZonePage(isFirstTime: true),
      },
    );
  }
}
