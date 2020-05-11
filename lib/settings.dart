import 'package:flutter/material.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/_reusable/widget/separator.dart';
import 'package:minaret/_reusable/widget/settings.dart';
import 'package:minaret/_reusable/widget/title.dart';
import 'package:minaret/logic/settings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          // settings time format
          FutureBuilder<bool>(
            future: sharedPrefIs12HourFormat(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return buildBoolSettingsItem(
                context,
                '12 hour format',
                'View prayer time in 12 hour format',
                snapshot.hasData ? snapshot.data : false,
                () async {
                  bool value = await sharedPrefIs12HourFormat();
                  await sharedPrefSet12HourFormat(!value);
                  setState(() {});
                },
              );
            },
          ),
          // settings theme
          buildEmptySettingsItem(
            context,
            'Theme',
            'Restart to apply theme',
            false,
            null,
          ),
          FutureBuilder<int>(
            future: sharedPrefGetTheme(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return buildBoolSubSettingsItem(
                context,
                'System theme',
                'Use system default theme',
                snapshot.hasData ? snapshot.data == THEME_SYSTEM : false,
                () async {
                  await sharedPrefSetTheme(THEME_SYSTEM);
                  setState(() {});
                },
              );
            },
          ),
          FutureBuilder<int>(
            future: sharedPrefGetTheme(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return buildBoolSubSettingsItem(
                context,
                'Light theme',
                'Recommended over daytime',
                snapshot.hasData ? snapshot.data == THEME_LIGHT : false,
                () async {
                  await sharedPrefSetTheme(THEME_LIGHT);
                  setState(() {});
                },
              );
            },
          ),
          FutureBuilder<int>(
            future: sharedPrefGetTheme(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return buildBoolSubSettingsItem(
                context,
                'Dark theme',
                'Recommended over nighttime',
                snapshot.hasData ? snapshot.data == THEME_DARK : false,
                () async {
                  await sharedPrefSetTheme(THEME_DARK);
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
