import 'package:flutter/material.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/separator.dart';
import 'package:minaret/widget/settings/hour_format.dart';
import 'package:minaret/widget/settings/theme.dart';
import 'package:minaret/widget/title.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        true,
        null,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle(context, 'Settings'),
          Text('Customize application\'s behavior'),
          buildSpaceSeparator(),
          buildListView(context),
        ],
      ),
      null,
    );
  }

  Widget buildListView(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          SettingsHourFormat(),
          SettingsTheme()
        ],
      ),
    );
  }
}
