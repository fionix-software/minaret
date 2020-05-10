import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildBoolSettingsItem(BuildContext context, String title, String subtitle, bool isSetEnable, Function onPressedCallback) {
  return ListTile(
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: IconButton(
      padding: EdgeInsets.all(5.0),
      icon: buildSettingsIcon(context, isSetEnable),
      onPressed: onPressedCallback,
    ),
    contentPadding: EdgeInsets.zero,
  );
}

Widget buildBoolSubSettingsItem(BuildContext context, String title, String subtitle, bool isSetEnable, Function onPressedCallback) {
  return ListTile(
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: IconButton(
      padding: EdgeInsets.all(5.0),
      icon: buildSettingsIcon(context, isSetEnable),
      onPressed: onPressedCallback,
    ),
    contentPadding: EdgeInsets.only(
      left: 20,
    ),
  );
}

Widget buildEmptySettingsItem(BuildContext context, String title, String subtitle, bool isSetEnable, Function onTapCallback) {
  return GestureDetector(
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      contentPadding: EdgeInsets.zero,
    ),
    onTap: onTapCallback,
  );
}

Widget buildSettingsIcon(BuildContext context, bool isSetEnable) {
  if (isSetEnable) {
    return Icon(
      FontAwesomeIcons.toggleOn,
      color: Theme.of(context).primaryColor,
    );
  }
  return Icon(
    FontAwesomeIcons.toggleOff,
    color: Theme.of(context).iconTheme.color,
  );
}
