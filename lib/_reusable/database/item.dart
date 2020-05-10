import 'package:sqflite/sqflite.dart';

abstract class DatabaseItem {
  Future<bool> create(Database db);
}
