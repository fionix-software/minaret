import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waktuku/database/database_helper.dart';
import 'package:waktuku/model/prayer_time.dart';
import 'package:waktuku/parse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Waktuku"),
        ),
        body: Center(
          child: Test(),
        ),
      ),
    );
  }
}

class Test extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TestState();
  }
}

class TestState extends State<Test> {
  ESolatParser parser = ESolatParser();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: parser.getZoneData("SGR03"),
      builder: (BuildContext c1, AsyncSnapshot<String> s1) {
        // get current date
        var formatter = new DateFormat('dd-MMM-yyyy');
        String formatted = formatter.format(DateTime.now());
        // parse json
        List<PrayerTimeData> data =
            (jsonDecode(s1.data)['prayerTime'] as List).map((i) {
          return PrayerTimeData.fromJson(i);
        }).toList();
        PrayerTimeData cur =
            data.singleWhere((i) => i.date.contains(formatted));
        DatabaseHelper.instance.ptInsert("SGR03", cur);
        // return
        return FutureBuilder<int>(
          future: DatabaseHelper.instance.ptInsert("SGR03", cur),
          builder: (BuildContext c2, AsyncSnapshot<int> s2) {
            return FutureBuilder<int>(
              future: DatabaseHelper.instance.ptRowCount(),
              builder: (BuildContext c3, AsyncSnapshot<int> s3) {
                return Text(s3.data.toString());
              },
            );
          },
        );
      },
    );
  }
}
