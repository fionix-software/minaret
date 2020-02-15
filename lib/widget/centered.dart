import 'package:flutter/material.dart';

// build common appbar
Widget buildCenteredWidget(List<Widget> widgets) {
  return SizedBox.expand(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    ),
  );
}
