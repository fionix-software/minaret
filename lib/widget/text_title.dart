import 'package:flutter/material.dart';

// build title text
Widget buildTextTitle(String titleStr) {
  return Padding(
    padding: EdgeInsets.only(top: 30, bottom: 5),
    child: Text(
      titleStr,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
      ),
    ),
  );
}
