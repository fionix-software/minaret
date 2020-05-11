import 'package:intl/intl.dart';
import 'package:minaret/_reusable/database/helper.dart';
import 'package:minaret/_reusable/database/item.dart';
import 'package:minaret/_reusable/database/util.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:minaret/model/pt_data.dart';

class DatabaseItemPrayerTime implements DatabaseItem {
  // table information
  final String ptTable = '_prayer_time_data';
  final String ptId = 'id';
  final String ptDate = 'date';
  final String ptZoneCode = 'zoneCode';
  final String ptZoneState = 'zoneState';
  final String ptZoneRegion = 'zoneRegion';
  final String ptHijri = 'hijri';
  final String ptDay = 'day';
  final String ptImsak = 'imsak';
  final String ptFajr = 'fajr';
  final String ptSyuruk = 'syuruk';
  final String ptDhuhr = 'dhuhr';
  final String ptAsr = 'asr';
  final String ptMaghrib = 'maghrib';
  final String ptIsha = 'isha';

  // for table creation
  Future<bool> create(Database db) async {
    try {
      await db.execute('''
      CREATE TABLE $ptTable (
        $ptId INTEGER PRIMARY KEY,
        $ptDate TEXT,
        $ptZoneCode TEXT,
        $ptZoneState TEXT,
        $ptZoneRegion TEXT,
        $ptHijri TEXT,
        $ptDay TEXT,
        $ptImsak TEXT,
        $ptFajr TEXT,
        $ptSyuruk TEXT,
        $ptDhuhr TEXT,
        $ptAsr TEXT,
        $ptMaghrib TEXT,
        $ptIsha TEXT
      );
    ''');
    } catch (e) {
      databaseErrorMessageLog('db_data.create', e);
      return false;
    }
    return true;
  }

  // get prayer data from date
  Future<PrayerTimeData> getPrayerTimeData(DateTime date) async {
    Database db = await DatabaseHelper.getInstance.getDatabase(this);
    // parse date as Malaysia time format
    String dateStr = DateFormat('dd MMMM yyyy').format(date);
    // get prayer data from date
    try {
      var onValue = await db.query(
        ptTable,
        where: '$ptDate=?',
        whereArgs: [
          dateStr,
        ],
      );
      if (onValue != null && onValue.isNotEmpty) {
        return PrayerTimeData.fromJson(onValue[0]);
      }
    } catch (e) {
      databaseErrorMessageLog('db_data.getPrayerTimeData', e);
      return null;
    }
    // error
    return null;
  }

  Future<bool> clearPrayerTimeData() async {
    Database db = await DatabaseHelper.getInstance.getDatabase(this);
    // clear all data
    try {
      await db.delete(ptTable);
    } catch (e) {
      databaseErrorMessageLog('db_data.clearPrayerTimeData.delete', e);
      return false;
    }
    return true;
  }

  // insert new data and delete old one if exist
  Future<bool> insert(Map<String, dynamic> data) async {
    Database db = await DatabaseHelper.getInstance.getDatabase(this);
    // delete existing
    try {
      await db.delete(
        ptTable,
        where: '$ptDate=? AND $ptZoneCode=?',
        whereArgs: [
          data['date'],
          data['zoneCode'],
        ],
      );
    } catch (e) {
      databaseErrorMessageLog('db_data.insert.delete', e);
      return false;
    }
    // insert new data
    try {
      await db.insert(ptTable, data);
    } catch (e) {
      databaseErrorMessageLog('db_data.insert.insert', e);
      return false;
    }
    return true;
  }
}
