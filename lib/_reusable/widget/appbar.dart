import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

AppBar buildAppBar(BuildContext context, bool enableCloseButton, List<Widget> appBarActions) {
  return AppBar(
    leading: (enableCloseButton)
        ? IconButton(
            icon: Icon(
              FontAwesomeIcons.times,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        : Container(),
    actions: appBarActions,
  );
}
