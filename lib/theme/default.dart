import 'package:flutter/material.dart';

const double titleTextSize = 20.0;
const double subheadTextSize = 16.0;
const double bodyTextSize = 12.0;

const Color defaultPrimaryColor = Color.fromARGB(255, 39, 174, 96);

ThemeData defaultThemeData() {
  return ThemeData(
    fontFamily: 'Varela',
    textTheme: TextTheme(
      title: TextStyle(
        fontSize: titleTextSize,
      ),
      subhead: TextStyle(
        fontSize: subheadTextSize,
      ),
      body1: TextStyle(
        fontSize: bodyTextSize,
      ),
    ),
    iconTheme: IconThemeData(
      size: 20.0,
      color: defaultPrimaryColor,
    ),
    primaryColor: defaultPrimaryColor,
  );
}
