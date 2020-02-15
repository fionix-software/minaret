import 'package:flutter/material.dart';
import 'package:minaret/logic/common.dart';

// build common big title text
Widget buildTextTitleBig(String titleStr) {
  return Padding(
    padding: EdgeInsets.only(top: 25),
    child: Text(
      titleStr,
      style: TextStyle(
        fontSize: 40,
        color: appThemeColor,
      ),
    ),
  );
}
