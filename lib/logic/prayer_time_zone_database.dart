import 'dart:async';

import 'package:sqflite/sqlite_api.dart';
import 'package:tuple/tuple.dart';

import 'package:waktuku/logic/common.dart';
import 'package:waktuku/model/prayer_time_zone.dart';

class DatabaseItemPrayerZone {
  final String ptTable = "_prayer_time_zone";
  final String ptId = "id";
  final String ptCode = "code";
  final String ptState = "state";
  final String ptRegion = "region";
  final String ptIsSelected = "isSelected";

  Future<ErrorStatusEnum> create(Database db) async {
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    try {
      await db.execute('''
      CREATE TABLE $ptTable (
        $ptId INTEGER PRIMARY KEY,
        $ptCode TEXT,
        $ptState TEXT,
        $ptRegion TEXT,
        $ptIsSelected INTEGER
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
      db.delete(ptTable, where: "$ptId=?", whereArgs: [id]);
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return returnStatus;
  }

  Future<Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>> getList(Database db) async {
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    List<PrayerTimeZone> list = List<PrayerTimeZone>();
    try {
      var onValue = await db.query(ptTable);
      if (onValue.isNotEmpty) {
        list = onValue.map((item) => PrayerTimeZone.fromJson(item)).toList();
      }
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>(returnStatus, list);
  }

  Future<Tuple2<ErrorStatusEnum, PrayerTimeZone>> getSelectedZone(Database db) async {
    PrayerTimeZone selectedZone;
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    try {
      var onValue = await db.query(ptTable, where: '$ptIsSelected=1');
      if (onValue.isNotEmpty) {
        selectedZone = PrayerTimeZone.fromJson(onValue[0]);
      }
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return Tuple2<ErrorStatusEnum, PrayerTimeZone>(returnStatus, selectedZone);
  }

  Future<ErrorStatusEnum> setSelectedZone(Database db, String code) async {
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    // unselect all selected zone
    try {
      db.rawUpdate('''
        UPDATE $ptTable
        SET $ptIsSelected=0
        WHERE $ptIsSelected=1
      ''');
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    // select zone
    try {
      db.rawUpdate('''
        UPDATE $ptTable
        SET $ptIsSelected=1
        WHERE $ptCode=?
      ''', [code]);
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return returnStatus;
  }

  ErrorStatusEnum insert(Database db, Map<String, dynamic> data) {
    ErrorStatusEnum returnStatus = ErrorStatusEnum.OK;
    try {
      db.insert(ptTable, data);
    } catch (e) {
      returnStatus = ErrorStatusEnum.ERROR;
    }
    return returnStatus;
  }
}
