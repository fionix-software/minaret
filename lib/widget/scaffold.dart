import 'package:flutter/material.dart';

// build common scaffold
Scaffold buildScaffold(AppBar appBar, Widget scaffoldBody, GlobalKey<ScaffoldState> globalKey) {
  return Scaffold(
    resizeToAvoidBottomPadding: false,
    key: globalKey,
    appBar: appBar,
    backgroundColor: Colors.white,
    body: ScrollConfiguration(
      behavior: MyBehavior(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          40,
          40,
          40,
          80,
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
