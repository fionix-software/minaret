import 'package:flutter/material.dart';
import 'package:minaret/widget/separator.dart';
import 'package:minaret/widget/title.dart';

Widget buildCardHeader(BuildContext context, String state, String code, String date, String dateHijri, String region) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildTitle(context, dateHijri),
        Text(date),
        buildSpaceSeparator(),
        buildTitle(context, state + " - " + code),
        Text(region),
        buildSpaceSeparator(),
      ],
    ),
  );
}
