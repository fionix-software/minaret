import 'package:flutter/material.dart';

Widget buildIcon(BuildContext context, IconData iconData, Function onPressCallback) {
  return IconButton(
    icon: Icon(
      iconData,
      color: Theme.of(context).primaryColor,
    ),
    onPressed: onPressCallback,
  );
}
