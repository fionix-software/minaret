import 'package:sqflite/sqlite_api.dart';
import 'package:tuple/tuple.dart';

import 'package:waktuku/logic/main_database.dart';
import 'package:waktuku/logic/common.dart';

class DatabaseItemPrayerTime extends DatabaseItemBase {
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

  @override
  ErrorStatus create(Database db) {
    ErrorStatus returnStatus = ErrorStatus.ERROR;
    db.execute('''
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
    ''').then((onValue) {
      returnStatus = ErrorStatus.OK;
    });
    return returnStatus;
  }

  @override
  ErrorStatus delete(Database db, int id) {
    ErrorStatus returnStatus = ErrorStatus.ERROR;
    db.delete(ptTable, where: "$ptId=?", whereArgs: [id.toString()]).then((onValue) {
      if (onValue == 1) {
        returnStatus = ErrorStatus.OK;
      }
    });
    return returnStatus;
  }

  @override
  Tuple2<ErrorStatus, PrayerTimeData> getList<PrayerTimeData>(Database db) {
    return null;
  }

  @override
  ErrorStatus insert(Database db, Map<String, dynamic> data) {
    ErrorStatus returnStatus = ErrorStatus.ERROR;
    db.insert(ptTable, data).then((onValue) {
      if (onValue == 1) {
        returnStatus = ErrorStatus.OK;
      }
    });
    return returnStatus;
  }
}
