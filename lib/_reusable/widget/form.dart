import 'package:flutter/material.dart';
import 'scaffold.dart';
import 'separator.dart';
import 'title.dart';

Widget buildForm(BuildContext context, AppBar appBar, String title, String subtitle, IconData yesButtonIcon, void Function() yesButtonCallback, IconData noButtonIcon, void Function() noButtonCallback) {
  return buildScaffold(
    appBar,
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTitle(context, title),
        Text(subtitle),
        buildSpaceExpanded(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(
                noButtonIcon,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: noButtonCallback,
            ),
            IconButton(
              icon: Icon(
                yesButtonIcon,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: yesButtonCallback,
            )
          ],
        )
      ],
    ),
  );
}
