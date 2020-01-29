import 'dart:io';

import 'package:tuple/tuple.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waktuku/logic/common.dart';
import 'package:path_provider/path_provider.dart';

abstract class DatabaseItemBase {
  // basic
  ErrorStatus create(Database db);
  ErrorStatus delete(Database db, int id);
  ErrorStatus insert(Database db, Map<String, dynamic> data);
  // templated
  Tuple2<ErrorStatus, A> getList<A>(Database db);
}

class DatabaseHelper {

  // database info
  static final _databaseName = "waktuku.db";
  static final _databaseVersion = 1;
  static List<DatabaseItemBase> databases;

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

    // insert all database item
    // databases.add(value);

    // return
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // sql query to create tables
  Future _onCreate(Database db, int version) async {
    // await db.execute(ptQueryCreate);
  }
}
