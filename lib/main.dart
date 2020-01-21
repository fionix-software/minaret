import 'package:flutter/material.dart';
import 'package:waktuku/home.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Varela',
      ),
      home: HomePage(),
    );
  }
}
