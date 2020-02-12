import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tuple/tuple.dart';

import 'package:waktuku/logic/common.dart';
import 'package:waktuku/model/prayer_time_data.dart';

class DatabaseItemPrayerTime {
  final String ptTable = "_prayer_time_data";
  final String ptId = "id";
  final String ptDate = "date";
  final String ptZone = "zone";
  final String ptHijri = "hijri";
  final String ptDay = "day";
  final String ptImsak = "imsak";
  final String ptFajr = "fajr";
  final String ptSyuruk = "syuruk";
  final String ptDhuhr = "dhuhr";
  final String ptAsr = "asr";
  final String ptMaghrib = "maghrib";
  final String ptIsha = "isha";

  Future<ErrorStatusEnum> create(Database db) async {
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    try {
      await db.execute('''
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
      );
    ''');
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return returnStatus;
  }

  ErrorStatusEnum delete(Database db, int id) {
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    try {
      db.delete(ptTable, where: "$ptId=?", whereArgs: [id.toString()]);
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return returnStatus;
  }

  Future<Tuple2<ErrorStatusEnum, PrayerTimeData>> getPrayerDataFromDate(Database db, String zone, DateTime date) async {
    PrayerTimeData data;
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    String dateStr = DateFormat('dd-MMM-yyyy').format(date);
    try {
      var onValue = await db.query(ptTable, where: "$ptDate=? AND $ptZone=?", whereArgs: [dateStr, zone]);
      if (onValue.isNotEmpty) {
        data = PrayerTimeData.fromJson(onValue[0]);
      }
    } catch (e) {
      log(e.toString());
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return Tuple2<ErrorStatusEnum, PrayerTimeData>(returnStatus, data);
  }

  Future<ErrorStatusEnum> insert(Database db, Map<String, dynamic> data) async {
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    // check for existing
    try {
      db.delete(ptTable, where: "$ptDate=? AND $ptZone=?", whereArgs: [data['date'], data['zone']]);
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    // insert new data
    try {
      db.insert(ptTable, data);
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return returnStatus;
  }
}
