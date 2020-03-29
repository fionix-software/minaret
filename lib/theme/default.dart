import 'package:flutter/material.dart';

const double titleTextSize = 20.0;
const double subheadTextSize = 16.0;
const double bodyTextSize = 12.0;

const Color defaultPrimaryColor = Color.fromARGB(255, 39, 174, 96);

class DefaultThemeData {
  // light
  static final ThemeData light = ThemeData(
    // app
    fontFamily: 'Varela',
    primaryColor: defaultPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    // app bar
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
    ),
    // card
    cardTheme: CardTheme(
      elevation: 0,
    ),
    // text
    textTheme: TextTheme(
      // used for creating title and card time
      title: TextStyle(
        fontSize: titleTextSize,
      ),
      // used for list tile title
      subhead: TextStyle(
        fontSize: subheadTextSize,
      ),
      // used for common text
      body1: TextStyle(
        fontSize: bodyTextSize,
      ),
    ),
    // icon
    iconTheme: IconThemeData(
      size: 20.0,
      color: Colors.black,
    ),
  );
  // dark
  static final ThemeData dark = ThemeData(
    // app
    fontFamily: 'Varela',
    primaryColor: defaultPrimaryColor,
    scaffoldBackgroundColor: Colors.black,
    // app bar
    appBarTheme: AppBarTheme(
      color: Colors.black,
      elevation: 0,
    ),
    // text
    textTheme: TextTheme(
      // used for creating title and card time
      title: TextStyle(
        fontSize: titleTextSize,
        color: Colors.white,
      ),
      // used for common text
      body1: TextStyle(
        fontSize: bodyTextSize,
        color: Colors.white,
      ),
      // used for list tile title
      subhead: TextStyle(
        fontSize: subheadTextSize,
        color: Colors.white,
      ),
      // used for list tile subtitle
      caption: TextStyle(
        color: Colors.white,
      ),
    ),
    // card
    cardTheme: CardTheme(
      color: Colors.black,
      elevation: 0,
    ),
    // icon
    iconTheme: IconThemeData(
      size: 20.0,
      color: Colors.white,
    ),
  );
}
