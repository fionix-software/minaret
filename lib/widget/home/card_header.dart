import 'package:flutter/material.dart';
import 'package:minaret/widget/screenTitle.dart';
import 'package:minaret/widget/separator.dart';

Widget buildCardHeader(String state, String code, String date, String dateHijri, String region) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildScreenTitle(dateHijri),
        Text(date),
        buildSpaceSeparator(),
        buildScreenTitle(state + " - " + code),
        Text(region),
        buildSpaceSeparator(),
      ],
    ),
  );
}
