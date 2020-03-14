import 'package:flutter/material.dart';
import 'package:minaret/widget/text_title_big.dart';

Widget buildHeader(String code, String date, String dateHijri, String region) {
  return Container(
    margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
    child: Column(
      children: <Widget>[
        buildTextTitleBig(code),
        Text(date),
        Text(dateHijri),
        Text(
          region,
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
