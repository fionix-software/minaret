import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/logic/common.dart';

Widget iconAbout(BuildContext context) {
  return IconButton(
    icon: Icon(
      FontAwesomeIcons.info,
      color: appThemeColor,
    ),
    onPressed: () {
      Navigator.pushNamed(context, '/about');
    },
  );
}
