import 'package:flutter/material.dart';
import 'package:minaret/logic/common.dart';

// build common big title text
Widget buildScreenTitle(String titleStr) {
  return Text(
    titleStr,
    style: TextStyle(
      fontSize: 25,
      color: appThemeColor,
    ),
  );
}
