import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/prayer_time_util.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/centered.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/text_title.dart';

class CheckingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckingPageState();
  }
}

class CheckingPageState extends State<CheckingPage> {
  // build
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        false,
        null,
      ),
      buildContent(context),
      null,
    );
  }

  // content
  Widget buildContent(BuildContext context) {
    return FutureBuilder(
      future: PrayerTimeUtil.checkPrayerDataStatus(),
      builder: (BuildContext context, AsyncSnapshot<ErrorStatusEnum> snapshot) {
        // set icon and text
        Icon icon = Icon(FontAwesomeIcons.syncAlt, size: 40, color: appThemeColor);
        if (snapshot.hasData) {
          if (snapshot.data == ErrorStatusEnum.OK) {
            // if ok, go /home
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
            });
          } else if (snapshot.data == ErrorStatusEnum.ERROR_GET_SELECTED_ZONE) {
            // if failed to get selected zone,set zone at /zone
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushReplacementNamed(context, '/zone/first-time');
            });
          } else {
            // display error message
            icon = Icon(FontAwesomeIcons.thumbsDown, size: 40, color: appThemeColor);
          }
        }
        // return widget
        return buildCenteredWidget(
          [
            icon,
            buildTextTitle(
              (snapshot.hasData) ? errorStatusEnumMap[snapshot.data] : 'Loading ..',
            ),
          ],
        );
      },
    );
  }
}
