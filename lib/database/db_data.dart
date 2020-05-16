import 'package:intl/intl.dart';
import 'package:minaret/_reusable/database/helper.dart';
import 'package:minaret/_reusable/database/item.dart';
import 'package:minaret/_reusable/database/util.dart';
import 'package:minaret/model/pt_zone.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:minaret/model/pt_data.dart';

class DatabaseItemPrayerTime implements DatabaseItem {
  // table information
  final String _ptTable = '_prayer_time_data';
  final String _ptId = 'id';
  final String _ptDate = 'date';
  final String _ptZoneCode = 'zoneCode';
  final String _ptZoneState = 'zoneState';
  final String _ptZoneRegion = 'zoneRegion';
  final String _ptHijri = 'hijri';
  final String _ptDay = 'day';
  final String _ptImsak = 'imsak';
  final String _ptFajr = 'fajr';
  final String _ptSyuruk = 'syuruk';
  final String _ptDhuhr = 'dhuhr';
  final String _ptAsr = 'asr';
  final String _ptMaghrib = 'maghrib';
  final String _ptIsha = 'isha';

  // for table creation
  Future<bool> create(Database db) async {
    try {
      await db.execute('''
      CREATE TABLE $_ptTable (
        $_ptId INTEGER PRIMARY KEY,
        $_ptDate TEXT,
        $_ptZoneCode TEXT,
        $_ptZoneState TEXT,
        $_ptZoneRegion TEXT,
        $_ptHijri TEXT,
        $_ptDay TEXT,
        $_ptImsak TEXT,
        $_ptFajr TEXT,
        $_ptSyuruk TEXT,
        $_ptDhuhr TEXT,
        $_ptAsr TEXT,
        $_ptMaghrib TEXT,
        $_ptIsha TEXT
      );
    ''');
    } catch (e) {
      databaseErrorMessageLog('db_data.create', e);
      return false;
    }
    return true;
  }

  Future<PrayerTimeZone> getPrayerTimeZone() async {
    Database db = await DatabaseHelper.getInstance.getDatabase(this);
    // get prayer zone
    try {
      var onValue = await db.rawQuery('SELECT DISTINCT $_ptZoneCode, $_ptZoneRegion, $_ptZoneState FROM $_ptTable');
      if (onValue != null || onValue.isNotEmpty) {
        return PrayerTimeZone.fromJson(onValue[0]);
      }
    } catch (e) {
      databaseErrorMessageLog('db_data.getPrayerTimeZone', e);
      return null;
    }
    return null;
  }

  Future<List<String>> getDateList() async {
    Database db = await DatabaseHelper.getInstance.getDatabase(this);
    // get prayer zone
    List<String> dateList = List<String>();
    try {
      var onValue = await db.rawQuery('SELECT $_ptDate FROM $_ptTable');
      if (onValue != null || onValue.isNotEmpty) {
        onValue.forEach((element) {
          dateList.add(element['$_ptDate']);
        });
        return dateList;
      }
    } catch (e) {
      databaseErrorMessageLog('db_data.getDateList', e);
      return null;
    }
    return null;
  }

  // get prayer data from date
  Future<PrayerTimeData> getPrayerTimeData(DateTime date) async {
    Database db = await DatabaseHelper.getInstance.getDatabase(this);
    // parse date as Malaysia time format
    String dateStr = DateFormat('dd MMMM yyyy').format(date);
    // get prayer data from date
    try {
      var onValue = await db.query(
        _ptTable,
        where: '$_ptDate=?',
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

  // get prayer data from date
  Future<bool> checkFirstTime() async {
    Database db = await DatabaseHelper.getInstance.getDatabase(this);
    // get prayer data
    try {
      var onValue = await db.query(
        _ptTable,
      );
      if (onValue != null && onValue.length > 0) {
        return false;
      }
    } catch (e) {
      databaseErrorMessageLog('db_data.getPrayerTimeData', e);
      return true;
    }
    // error
    return true;
  }

  Future<bool> clearPrayerTimeData() async {
    Database db = await DatabaseHelper.getInstance.getDatabase(this);
    // clear all data
    try {
      await db.delete(_ptTable);
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
        _ptTable,
        where: '$_ptDate=? AND $_ptZoneCode=?',
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
      await db.insert(_ptTable, data);
    } catch (e) {
      databaseErrorMessageLog('db_data.insert.insert', e);
      return false;
    }
    return true;
  }
}
