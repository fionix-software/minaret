import 'package:flutter/material.dart';

import 'package:minaret/about.dart';
import 'package:minaret/home.dart';
import 'package:minaret/logic/settings.dart';
import 'package:minaret/settings.dart';
import 'package:minaret/theme/default.dart';
import 'package:minaret/zone.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: sharedPrefGetTheme(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Minaret',
          theme: (snapshot.hasData && snapshot.data == THEME_DARK) ? DefaultThemeData.dark : DefaultThemeData.light,
          darkTheme: (snapshot.hasData && snapshot.data == THEME_LIGHT) ? DefaultThemeData.light : DefaultThemeData.dark,
          initialRoute: '/home',
          routes: {
            '/home': (_) => HomePage(),
            '/about': (_) => AboutPage(),
            '/zone': (_) => ZonePage(),
            '/settings': (_) => SettingsPage(),
          },
        );
      },
    );
  }
}
