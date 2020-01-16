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
  static final ptTable = "_prayer_time";
  static final ptId = "id";
  static final ptDate = "date";
  static final ptZone = "zone";
  static final ptHijri = "hijri";
  static final ptDay = "day";
  static final ptImsak = "imsak";
  static final ptFajr = "fajr";
  static final ptSyuruk = "syuruk";
  static final ptDhuhr = "dhuhr";
  static final ptAsr = "asr";
  static final ptMaghrib = "maghrib";
  static final ptIsha = "isha";
  static final ptQueryCreate = '''
      CREATE TABLE $ptTable (
        $ptId INTEGER PRIMARY KEY,
        $ptDate TEXT,
        $ptZone TEXT,
        $ptHijri TEXT,
        $ptDay TEXT,
        $ptImsak TEXT,
        $ptFajr TEXT,
        $ptSyuruk TEXT,
        $ptDhuhr TEXT,
        $ptAsr TEXT,
        $ptMaghrib TEXT,
        $ptIsha TEXT
      )
    ''';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper getInstance = DatabaseHelper._privateConstructor();

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
    await db.execute(ptQueryCreate);
  }

  // helper: get row count
  Future<int> ptRowCount() async {
    Database db = await getInstance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $ptTable'));
  }

  // helper: insert new data
  Future<int> ptInsert(String zone, PrayerTimeData newData) async {
    // get database
    Database database = await getInstance.database;

    // check existing entry
    List<String> columnsToSelect = [
      ptId,
      ptZone,
      ptDate,
    ];
    List<Map> result = await database.query(
      ptTable,
      columns: columnsToSelect,
      where: "$ptZone=? AND $ptDate=?",
      whereArgs: [zone, newData.date],
    );

    // delete if there is existing
    if (result.isNotEmpty) {
      result.forEach((row) {
        database.delete(ptTable, where: "$ptId=?", whereArgs: [row['id']]);
      });
    }

    // map new data
    Map<String, dynamic> values = {
      ptZone: zone,
      ptDate: newData.date,
      ptHijri: newData.hijri,
      ptDay: newData.day,
      ptImsak: newData.imsak,
      ptFajr: newData.fajr,
      ptSyuruk: newData.syuruk,
      ptDhuhr: newData.dhuhr,
      ptAsr: newData.asr,
      ptMaghrib: newData.maghrib,
      ptIsha: newData.isha,
    };

    // return
    return await database.insert(ptTable, values);
  }
}
