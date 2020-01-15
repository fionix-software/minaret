import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:waktuku/model/prayer_time.dart';

class DatabaseHelper {
  // database info
  static final _databaseName = "waktuku.db";
  static final _databaseVersion = 1;

  // prayer time table info
  static final _pt_table = "_prayer_time";
  static final _pt_id = "id";
  static final _pt_date = "date";
  static final _pt_zone = "zone";
  static final _pt_hijri = "hijri";
  static final _pt_day = "day";
  static final _pt_imsak = "imsak";
  static final _pt_fajr = "fajr";
  static final _pt_syuruk = "syuruk";
  static final _pt_dhuhr = "dhuhr";
  static final _pt_asr = "asr";
  static final _pt_maghrib = "maghrib";
  static final _pt_isha = "isha";
  static final _pt_create = '''
      CREATE TABLE $_pt_table (
        $_pt_id INTEGER PRIMARY KEY,
        $_pt_date TEXT,
        $_pt_zone TEXT,
        $_pt_hijri TEXT,
        $_pt_day TEXT,
        $_pt_imsak TEXT,
        $_pt_fajr TEXT,
        $_pt_syuruk TEXT,
        $_pt_dhuhr TEXT,
        $_pt_asr TEXT,
        $_pt_maghrib TEXT,
        $_pt_isha TEXT
      )
    ''';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // create a database instance if not yet init
  static Database _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  // init database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // sql query to create tables
  Future _onCreate(Database db, int version) async {
    await db.execute(_pt_create);
  }

  // helper: get row count
  Future<int> ptRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_pt_table'));
  }

  // helper: insert new data
  Future<int> ptInsert(String zone, PrayerTimeData new_data) async {
    // get database
    Database database = await instance.database;

    // check existing entry
    List<String> columnsToSelect = [
      _pt_id,
      _pt_zone,
      _pt_date,
    ];
    List<Map> result = await database.query(
      _pt_table,
      columns: columnsToSelect,
      where: "$_pt_zone=? AND $_pt_date=?",
      whereArgs: [zone, new_data.date],
    );

    // delete if there is existing
    if (result.isNotEmpty) {
      result.forEach((row) {
        database.delete(_pt_table, where: "$_pt_id=?", whereArgs: [row['id']]);
      });
    }

    // map new data
    Map<String, dynamic> values = {
      _pt_zone: zone,
      _pt_date: new_data.date,
      _pt_hijri: new_data.hijri,
      _pt_day: new_data.day,
      _pt_imsak: new_data.imsak,
      _pt_fajr: new_data.fajr,
      _pt_syuruk: new_data.syuruk,
      _pt_dhuhr: new_data.dhuhr,
      _pt_asr: new_data.asr,
      _pt_maghrib: new_data.maghrib,
      _pt_isha: new_data.isha,
    };

    // return
    return await database.insert(_pt_table, values);
  }
}
