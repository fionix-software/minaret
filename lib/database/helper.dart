import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/database/db_data.dart';
import 'package:minaret/database/db_zone.dart';

class DatabaseHelper {
  // database info
  static final _databaseName = "minaret.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper getInstance = DatabaseHelper._privateConstructor();

  // create a database instance if not yet init
  static Database _database;
  Future<Database> get database async {
    return ((_database != null) ? _database : _database = await _initDatabase());
  }

  // init database
  _initDatabase() async {
    // open database and create database item if not yet created
    final String path = (await getApplicationDocumentsDirectory()).path + _databaseName;
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // sql query to create tables
  Future _onCreate(Database db, int version) async {
    // create database
    if (await DatabaseItemPrayerTime().create(db) != ErrorStatusEnum.OK || await DatabaseItemPrayerZone().create(db) != ErrorStatusEnum.OK) {
      log("Unable to create database items");
    }
  }
}
