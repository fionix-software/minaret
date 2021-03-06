import 'package:flutter/material.dart';
import 'package:minaret/_reusable/logic/intermediate.dart';
import 'package:minaret/_reusable/logic/sharedpref.dart';
import 'package:minaret/_reusable/screen/intermediate.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/list.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/_reusable/widget/settings.dart';
import 'package:minaret/logic/sharedpref.dart';

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
      ),
      buildListView(
        context,
        'Settings',
        'Customize application\'s behavior',
        false,
        ListView(
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
            // reset tutorial theme
            buildEmptySettingsItem(
              context,
              'Tutorial',
              'Click here to display tutorial at home screen',
              false,
              () async {
                bool status = await sharedPrefTutorialHomeScreenResetComplete();
                if (status) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntermediateScreen(intermediateSettingsMap[IntermediateEnum.SUCCESS]),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
