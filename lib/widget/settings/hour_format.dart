import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/logic/settings.dart';

class SettingsHourFormat extends StatefulWidget {
  @override
  _SettingsHourFormatState createState() => _SettingsHourFormatState();
}

class _SettingsHourFormatState extends State<SettingsHourFormat> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('12 hour format'),
      subtitle: Text('View prayer time in 12 hour format'),
      trailing: IconButton(
        padding: EdgeInsets.all(5.0),
        icon: FutureBuilder<bool>(
          future: sharedPrefIs12HourFormat(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data) {
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
          bool value = await sharedPrefIs12HourFormat();
          await sharedPrefSet12HourFormat(!value);
          setState(() {});
        },
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
