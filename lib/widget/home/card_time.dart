import 'package:flutter/material.dart';
import 'package:minaret/logic/settings.dart';
import 'package:minaret/logic/util.dart';

Widget buildTimeCard(BuildContext context, String salatTime, String time) {
  return Card(
    margin: EdgeInsets.zero,
    child: Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(salatTime),
          FutureBuilder<bool>(
            future: sharedPrefIs12HourFormat(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                String displayTime = time;
                if (snapshot.data) {
                  displayTime = convert12HourTimeFormat(time);
                }
                return buildTimeText(context, displayTime);
              }
              return buildTimeText(context, 'n/a');
            },
          ),
        ],
      ),
    ),
  );
}

Widget buildTimeText(BuildContext context, String time) {
  return Text(
    time,
    style: TextStyle(
      fontSize: Theme.of(context).textTheme.title.fontSize,
    ),
  );
}
//
