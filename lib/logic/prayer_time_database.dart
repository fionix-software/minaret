import 'package:sqflite/sqlite_api.dart';
import 'package:tuple/tuple.dart';

import 'package:waktuku/logic/database.dart';
import 'package:waktuku/logic/common_enum.dart';

class DatabaseItemPrayerTime extends DatabaseItemBase {
  final String ptTable = "_prayer_time";
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
  StatusEnum create(Database db) {
    StatusEnum returnStatus = StatusEnum.NOT_GOOD;
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
      returnStatus = StatusEnum.GOOD;
    });
    return returnStatus;
  }

  @override
  StatusEnum delete(Database db, int id) {
    StatusEnum returnStatus = StatusEnum.NOT_GOOD;
    db.delete(ptTable, where: "$ptId=?", whereArgs: [id.toString()]).then((onValue) {
      if (onValue == 1) {
        returnStatus = StatusEnum.GOOD;
      }
    });
    return returnStatus;
  }

  @override
  Tuple2<StatusEnum, PrayerTimeData> getList<PrayerTimeData>(Database db) {
    return null;
  }

  @override
  StatusEnum insert(Database db, Map<String, dynamic> data) {
    StatusEnum returnStatus = StatusEnum.NOT_GOOD;
    db.insert(ptTable, data).then((onValue) {
      if (onValue == 1) {
        returnStatus = StatusEnum.GOOD;
      }
    });
    return returnStatus;
  }
}
