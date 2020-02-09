import 'dart:developer';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:waktuku/logic/common.dart';
import 'package:waktuku/logic/prayer_time_data_database.dart';
import 'package:waktuku/logic/prayer_time_zone_database.dart';

class DatabaseHelper {
  // database info
  static final _databaseName = "waktuku.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper getInstance = DatabaseHelper._privateConstructor();

  // create a database instance if not yet init
  static Database _database;
  Future<Database> get database async {
    // check if database initialized before
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  // init database
  _initDatabase() async {
    // get database part
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + _databaseName;

    // return
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // sql query to create tables
  Future _onCreate(Database db, int version) async {
      // create database
      if (await DatabaseItemPrayerTime().create(db) != ErrorStatusEnum.OK)
      {
        log("Prayer time database create failed");
      }
      // create database
      if (await DatabaseItemPrayerZone().create(db) != ErrorStatusEnum.OK)
      {
        log("Prayer zone database create failed");
      }
  }
}
