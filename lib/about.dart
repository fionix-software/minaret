import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:minaret/widget/appbar.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/text_title.dart';

class AboutPage extends StatelessWidget {
  // build
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        true,
        null,
      ),
      buildContent(),
      null,
    );
  }

  // content
  Widget buildContent() {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'img/fionix.png',
            height: 80,
          ),
          buildTextTitle('Minaret'),
          Text('Open Source Software'),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              return (snapshot.hasData)
                  ? Text('version ${snapshot.data.version} (${snapshot.data.buildNumber})')
                  : Text('version n/a');
            },
          ),
          Text('by Fionix'),
          buildTextTitle('Credits:'),
          Text('Tuple (BSD 2 Clause)'),
          Text('SQFLite (BSD 2 Clause)'),
          Text('Varela Font (Open Font)'),
          Text('Font Awesome Icons (CC by 4.0)'),
        ],
      ),
    );
  }
}
