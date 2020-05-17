import 'package:flutter/material.dart';
import '../logic/intermediate.dart';
import '../widget/appbar.dart';
import '../widget/scaffold.dart';

class IntermediateScreen extends StatelessWidget {
  final IntermediateScreenSettings settings;
  final void Function() retryCallback;
  final String additionalMessage;
  IntermediateScreen(this.settings, [this.retryCallback, this.additionalMessage]);

  @override
  Widget build(BuildContext context) {
    return buildScaffold(
      buildAppBar(
        context,
        settings.isCloseEnabled,
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                padding: EdgeInsets.all(15),
                icon: Icon(
                  settings.iconData,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: retryCallback,
              ),
              Text(
                (additionalMessage != null) ? additionalMessage + ' ' + settings.message : settings.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
