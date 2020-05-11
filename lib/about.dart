import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/_reusable/widget/appbar.dart';
import 'package:minaret/_reusable/widget/icon.dart';
import 'package:minaret/_reusable/widget/scaffold.dart';
import 'package:minaret/_reusable/widget/separator.dart';
import 'package:minaret/_reusable/widget/title.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        true,
        [
          buildIcon(
            context,
            FontAwesomeIcons.globe,
            () async {
              final String url = 'https://fionix.net/';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          ),
          buildIcon(
            context,
            FontAwesomeIcons.github,
            () async {
              final String url = 'https://github.com/fionix-software/minaret';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          ),
        ],
      ),
      buildContent(context),
      null,
    );
  }

  Widget buildContent(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildTitle(context, 'Minaret'),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              String version = (snapshot.hasData) ? ('Version ' + snapshot.data.version + ' (build ' + snapshot.data.buildNumber + ')') : '';
              return Text(version);
            },
          ),
          Text('Developed Fionix Software'),
          Text('Free and open source software'),
          buildSpaceSeparator(),
          buildTitle(context, 'Third Party Credit'),
          Text('Varela Font (Open Font)'),
          Text('Font Awesome Icons (CC by 4.0)'),
          Text('SQFLite lib (MIT)'),
          Text('Equatable lib (MIT)'),
          Text('Flutter Bloc lib (MIT)'),
          Text('Flutter Launcher Icon lib (MIT)'),
          buildSpaceSeparator(),
          buildTitle(context, 'Disclaimer'),
          Text('All timetable data is hosted by JAKIM e-Solat portal.'),
        ],
      ),
    );
  }
}
