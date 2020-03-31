import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/logic/settings.dart';

class SettingsTheme extends StatefulWidget {
  @override
  _SettingsThemeState createState() => _SettingsThemeState();
}

class _SettingsThemeState extends State<SettingsTheme> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // parent
        ListTile(
          title: Text('Theme'),
          subtitle: Text('Restart to apply theme'),
          contentPadding: EdgeInsets.zero,
        ),
        // child
        childSettings('System theme', 'Use system default theme', THEME_SYSTEM),
        childSettings('Light theme', 'Recommended over daytime', THEME_LIGHT),
        childSettings('Dark theme', 'Recommended over nighttime', THEME_DARK),
      ],
    );
  }

  Widget childSettings(String title, String subtitile, int themeSettings) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitile),
      trailing: IconButton(
        padding: EdgeInsets.all(5.0),
        icon: FutureBuilder<int>(
          future: sharedPrefGetTheme(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData && snapshot.data == themeSettings) {
              return Icon(
                FontAwesomeIcons.toggleOn,
                color: Theme.of(context).primaryColor,
              );
            }
            return Icon(
              FontAwesomeIcons.toggleOff,
              color: Theme.of(context).iconTheme.color,
            );
          },
        ),
        onPressed: () async {
          await sharedPrefSetTheme(themeSettings);
          setState(() {});
        },
      ),
      contentPadding: EdgeInsets.only(
        left: 20,
      ),
    );
  }
}
