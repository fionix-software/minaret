import 'package:flutter/material.dart';
import 'package:waktuku/logic/controller.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getZoneList(),
      builder: (BuildContext c2, AsyncSnapshot<List<String>> s2) {
        String s = "";
        for (String item in s2.data) {
          s = s + item + "\n";
        }
        return Text(s);
      },
    );
  }
}
