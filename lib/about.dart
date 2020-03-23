import 'package:flutter/material.dart';
import 'package:minaret/widget/about/icon_github.dart';
import 'package:minaret/widget/about/icon_site.dart';
import 'package:minaret/widget/screenTitle.dart';
import 'package:minaret/widget/separator.dart';
import 'package:package_info/package_info.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/scaffold.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        true,
        [
          iconGithub(context),
          iconSite(context),
        ],
      ),
      buildContent(),
      null,
    );
  }

  Widget buildContent() {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildScreenTitle('Minaret'),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              String version = (snapshot.hasData) ? ('Version ' + snapshot.data.version + ' (build ' + snapshot.data.buildNumber + ')') : '';
              return Text(version);
            },
          ),
          Text('Open source software by Fionix'),
          buildSpaceSeparator(),
          buildScreenTitle('Third Party Credit'),
          Text('Varela Font (Open Font)'),
          Text('Font Awesome Icons (CC by 4.0)'),
          Text('SQFLite lib (MIT)'),
          Text('Equatable lib (MIT)'),
          Text('Flutter Bloc lib (MIT)'),
          Text('Flutter Launcher Icon lib (MIT)'),
          buildSpaceSeparator(),
          buildScreenTitle('Disclaimer'),
          Text('All data only applicable for Malaysia only.'),
          Text('All prayer time data is hosted by e-Solat portal.'),
          Text('We doesn\'t collect any personal and sensitive data.'),
        ],
      ),
    );
  }
}
