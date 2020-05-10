import 'package:flutter/material.dart';

Widget buildTitle(BuildContext context, String titleStr) {
  return Text(
    titleStr,
    style: TextStyle(
      fontSize: Theme.of(context).textTheme.headline6.fontSize,
      color: Theme.of(context).primaryColor,
    ),
  );
}
