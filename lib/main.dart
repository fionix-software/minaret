import 'package:flutter/material.dart';

import 'package:minaret/about.dart';
import 'package:minaret/home.dart';
import 'package:minaret/settings.dart';
import 'package:minaret/zone.dart';
import 'package:minaret/theme/default.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minaret',
      theme: DefaultThemeData.light,
      darkTheme: DefaultThemeData.dark,
      initialRoute: '/home',
      routes: {
        '/home': (_) => HomePage(),
        '/about': (_) => AboutPage(),
        '/zone': (_) => ZonePage(),
        '/settings': (_) => SettingsPage(),
      },
    );
  }
}
