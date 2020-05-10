import 'package:flutter/material.dart';

Widget buildIcon(BuildContext context, IconData iconData, Colors iconColor, Function onPressCallback) {
  return IconButton(
    icon: Icon(
      iconData,
      color: (iconColor == null) ? Theme.of(context).primaryColor : iconColor,
    ),
    onPressed: onPressCallback,
  );
}
