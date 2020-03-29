import 'package:flutter/material.dart';
import 'package:minaret/logic/progress.dart';
import 'package:minaret/widget/scaffold.dart';

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
              padding: EdgeInsets.all(5),
              icon: Icon(
                data.icon,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                // call callback (only applicable to ERROR screen)
                if (retryCallback != null) {
                  retryCallback();
                }
              },
            ),
            Text(
              data.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.subhead.fontSize,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      null,
    );
  }
}
