import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/logic/common.dart';

// build common appbar
AppBar buildAppBar(BuildContext context, bool enableBackButton, List<Widget> appBarActions) {
  return AppBar(
    leading: (enableBackButton)
        ? IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              color: appThemeColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        : Container(),
    backgroundColor: Colors.white,
    actions: appBarActions,
    elevation: 0,
  );
}
