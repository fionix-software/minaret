import 'package:flutter/material.dart';

class Configuration {
  static const int DATABASE_VERSION = 2;
  static const String DATABASE_NAME = 'minaret';
  static const Color flavorColor = Color.fromARGB(255, 39, 174, 96);
}

/* 
 * Version
 * -------
 * 20200512-2
 *
 * Language 
 * --------
 * Dart
 * 
 * Framework
 * ---------
 * Flutter
 * 
 * Dependencies
 * ------------
 * You need to add these packages into 'pubspec.yaml' file:- 
 * - http
 * - sqflite
 * - path_provider
 * - font_awesome_flutter
 * - flutter_launcher_icons
 * 
 * Please get the latest package version from 'https://pub.dev/'
 * 
 * Instruction
 * -----------
 * Copy dart-flutter directory content to '_reusable' inside lib directory
 * Linux command: 'cp -r dart-flutter/ ${project-path}/lib/; mv ${project-path}/lib/dart-flutter ${project-path}/lib/_reusable'
 * 
 */
