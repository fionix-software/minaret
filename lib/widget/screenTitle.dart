import 'package:flutter/material.dart';
import 'package:minaret/logic/common.dart';

// build common big title text
Widget buildScreenTitle(String titleStr) {
  return Padding(
    padding: EdgeInsets.only(top: 0),
    child: Text(
      titleStr,
      style: TextStyle(
        fontSize: 35,
        color: appThemeColor,
      ),
    ),
  );
}
