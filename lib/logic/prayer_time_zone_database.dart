import 'package:sqflite/sqlite_api.dart';
import 'package:tuple/tuple.dart';

import 'package:waktuku/logic/main_database.dart';
import 'package:waktuku/logic/common.dart';

class DatabaseItemPrayerTime extends DatabaseItemBase {
  final String ptTable = "_prayer_time_zone";
  final String ptId = "id";
  final String ptCode = "code";
  final String ptState = "state";
  final String ptRegion = "region";
  final String ptIsSelected = "isSelected";

  @override
  ErrorStatus create(Database db) {
    ErrorStatus returnStatus = ErrorStatus.ERROR;
    db.execute('''
      CREATE TABLE $ptTable (
        $ptId INTEGER PRIMARY KEY,
        $ptCode TEXT,
        $ptState TEXT,
        $ptRegion TEXT,
        $ptIsSelected INTEGER,
      )
    ''').then((onValue) {
      returnStatus = ErrorStatus.OK;
    });
    return returnStatus;
  }

  @override
  ErrorStatus delete(Database db, int id) {
    ErrorStatus returnStatus = ErrorStatus.ERROR;
    db.delete(ptTable, where: "$ptId=?", whereArgs: [id]).then((onValue) {
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
