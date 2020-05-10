import 'package:flutter/material.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/_reusable/widget/separator.dart';
import 'package:minaret/_reusable/widget/title.dart';

Widget buildForm(BuildContext context, String title, String subtitle, IconData yesButtonIcon, void Function() yesButtonCallback, IconData noButtonIcon, void Function() noButtonCallback) {
  return buildScaffold(
    buildAppBar(
      context,
      false,
      null,
    ),
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
    null,
  );
}
