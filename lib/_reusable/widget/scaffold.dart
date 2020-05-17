import 'package:flutter/material.dart';

Scaffold buildScaffold(AppBar appBar, Widget scaffoldBody, [GlobalKey<ScaffoldState> globalKey]) {
  return Scaffold(
    resizeToAvoidBottomPadding: false,
    key: globalKey,
    appBar: appBar,
    body: ScrollConfiguration(
      behavior: MyBehavior(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          40,
          20,
          40,
          40,
        ),
        child: scaffoldBody,
      ),
    ),
  );
}

// to remove scroll glow entirely
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
