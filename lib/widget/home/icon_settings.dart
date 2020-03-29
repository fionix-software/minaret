import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget iconSettings(BuildContext context) {
  return IconButton(
    icon: Icon(
      FontAwesomeIcons.cog,
      color: Theme.of(context).primaryColor,
    ),
    onPressed: () {
      Navigator.pushNamed(context, '/settings');
    },
  );
}
