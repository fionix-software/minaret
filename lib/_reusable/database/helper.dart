import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:minaret/_reusable/config.dart';
import 'package:minaret/_reusable/database/item.dart';

typedef CreateFunction = Future<bool> Function(Database);

class DatabaseHelper {
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper getInstance = DatabaseHelper._privateConstructor();

  // create a database instance if not yet init
  static Database _database;
  Future<Database> getDatabase(DatabaseItem databaseItem) async {
    return ((_database != null) ? _database : _database = await _initDatabase(databaseItem));
  }

  // init database
  _initDatabase(DatabaseItem databaseItem) async {
    // open database and create database item if not yet created
    final String path = (await getApplicationDocumentsDirectory()).path + Configuration.DATABASE_NAME;
    return await openDatabase(path, version: Configuration.DATABASE_VERSION, onCreate: (Database db, int version) async {
      // create database
      bool status = await databaseItem.create(db);
      if (!status) {
        log("Unable to create database items");
      }
    });
  }
}
