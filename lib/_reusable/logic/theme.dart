import 'package:flutter/material.dart';

import '../config.dart';

const double titleTextSize = 20.0;
const double subheadTextSize = 16.0;
const double bodyTextSize = 12.0;
const String fontFamily = 'Varela';

class DefaultThemeData {
  // light
  static final ThemeData light = ThemeData(
    // app
    fontFamily: fontFamily,
    primaryColor: Configuration.flavorColor,
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
      headline6: TextStyle(
        fontSize: titleTextSize,
      ),
      // used for list tile title
      subtitle1: TextStyle(
        fontSize: subheadTextSize,
      ),
      // used for common text
      bodyText2: TextStyle(
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
    fontFamily: fontFamily,
    primaryColor: Configuration.flavorColor,
    scaffoldBackgroundColor: Colors.black,
    // app bar
    appBarTheme: AppBarTheme(
      color: Colors.black,
      elevation: 0,
    ),
    // text
    textTheme: TextTheme(
      // used for creating title and card time
      headline6: TextStyle(
        fontSize: titleTextSize,
        color: Colors.white,
      ),
      // used for common text
      bodyText2: TextStyle(
        fontSize: bodyTextSize,
        color: Colors.white,
      ),
      // used for list tile title
      subtitle1: TextStyle(
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
