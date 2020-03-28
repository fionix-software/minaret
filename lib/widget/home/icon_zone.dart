import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget iconZone(BuildContext context) {
  return IconButton(
    icon: Icon(
      FontAwesomeIcons.mapMarker,
      color: Theme.of(context).primaryColor,
    ),
    onPressed: () {
      Navigator.pushNamed(context, '/zone');
    },
  );
}
