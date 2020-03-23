import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/logic/common.dart';
import 'package:url_launcher/url_launcher.dart';

Widget iconSite(BuildContext context) {
  return IconButton(
    icon: Icon(
      FontAwesomeIcons.globe,
      color: appThemeColor,
    ),
    onPressed: () async {
      const String url = 'https://fionix.net/';
      if (await canLaunch(url)) {
        await launch(url);
      }
    },
  );
}