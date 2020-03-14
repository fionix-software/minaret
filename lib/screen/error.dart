import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/logic/common.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  ErrorScreen(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      null,
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.syncAlt, size: 40, color: appThemeColor),
            SizedBox(height: 20),
            Text(
              errorMessage,
              style: TextStyle(
                color: appThemeColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      null,
    );
  }
}
