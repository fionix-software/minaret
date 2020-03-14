import 'package:flutter/material.dart';
import 'package:minaret/widget/screenTitle.dart';

Widget buildHeader(String state, String code, String date, String dateHijri, String region) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildScreenTitle(dateHijri),
        Text(date),
        SizedBox(height: 40),
        buildScreenTitle(state + " - " + code),
        Text(region),
        SizedBox(height: 40),
      ],
    ),
  );
}
