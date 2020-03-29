import 'package:flutter/material.dart';

Widget buildTimeCard(BuildContext context, String salatTime, String time) {
  return Card(
    margin: EdgeInsets.zero,
    child: Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(salatTime),
          Text(
            time,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.title.fontSize,
            ),
          ),
        ],
      ),
    ),
  );
}
