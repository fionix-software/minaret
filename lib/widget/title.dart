import 'package:flutter/material.dart';

// build common big title text
Widget buildTitle(BuildContext context, String titleStr) {
  return Text(
    titleStr,
    style: TextStyle(
      fontSize: Theme.of(context).textTheme.title.fontSize,
      color: Theme.of(context).primaryColor,
    ),
  );
}
