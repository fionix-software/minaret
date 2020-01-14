import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waktuku/model/prayerTimeData.dart';
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
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // get current date
        var formatter = new DateFormat('dd-MMM-yyyy');
        String formatted = formatter.format(DateTime.now());
        // parse json
        List<PrayerTimeData> data =
            (jsonDecode(snapshot.data)['prayerTime'] as List).map((i) {
          return PrayerTimeData.fromJson(i);
        }).toList();
        PrayerTimeData cur =
            data.singleWhere((i) => i.date.contains(formatted));
        // return
        return Text(cur.date + "; " + cur.hijri);
      },
    );
  }
}
