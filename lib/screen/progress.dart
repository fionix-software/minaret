import 'package:flutter/material.dart';
import 'package:minaret/logic/progress.dart';
import 'package:minaret/widget/scaffold.dart';
import 'package:minaret/logic/common.dart';

typedef RetryCallback = void Function();

class ProgressScreen extends StatelessWidget {
  final ProgressStruct data;
  final RetryCallback retryCallback;
  ProgressScreen(this.data, [this.retryCallback]);

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      null,
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                data.icon,
                size: 40,
                color: appThemeColor,
              ),
              onPressed: () {
                // call callback (only applicable to ERROR screen)
                if (retryCallback != null) {
                  retryCallback();
                }
              },
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
