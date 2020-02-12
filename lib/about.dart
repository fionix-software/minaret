import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';

import 'package:waktuku/logic/common.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: appThemeColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: 40,
          right: 40,
          bottom: 40,
        ),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'img/fionix.png',
                height: 80,
              ),
              SizedBox(height: 30),
              Text(
                'Waktuku',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              FutureBuilder(
                future: getVersion(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Text('version ${snapshot.data}');
                },
              ),
              Text('Waktuku is a rebrand of Moments Log.'),
              Text(
                'All data is retrieved from e-Solat using web scraping technique.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Developer:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Nazeb Zurati (Fionix)'),
              SizedBox(height: 20),
              Text(
                'Open source credits:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Tuple (BSD 2 Clause)'),
              Text('SQFLite (BSD 2 Clause)'),
              Text('Varela Font (Open Font)'),
              Text('Font Awesome Icons (CC by 4.0)'),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version + " (" + packageInfo.buildNumber + ")";
  }
}
