import 'package:flutter/material.dart';

Widget buildIcon(BuildContext context, IconData iconData, Function onPressCallback, [GlobalKey globalKey]) {
  return IconButton(
    icon: Icon(
      iconData,
      color: Theme.of(context).primaryColor,
    ),
    onPressed: onPressCallback,
    key: globalKey,
  );
}
