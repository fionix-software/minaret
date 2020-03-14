import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/widget/centered.dart';
import 'package:minaret/widget/text_title.dart';
import 'package:minaret/logic/common.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      null,
      buildCenteredWidget(
        [
          Icon(FontAwesomeIcons.syncAlt, size: 40, color: appThemeColor),
          buildTextTitle('Loading ..'),
        ],
      ),
      null,
    );
  }
}
