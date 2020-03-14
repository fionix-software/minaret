import 'package:flutter/material.dart';
import 'package:minaret/logic/progress.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/logic/common.dart';

class ProgressScreen extends StatelessWidget {
  final ProgressStruct data;
  ProgressScreen(this.data);

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      null,
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              data.icon,
              size: 40,
              color: appThemeColor,
            ),
            SizedBox(height: 20),
            Text(
              data.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: appThemeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      null,
    );
  }
}
