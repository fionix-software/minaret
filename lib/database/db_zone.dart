import 'package:sqflite/sqlite_api.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/model/pt_zone.dart';

class DatabaseItemPrayerZone {
  // table information
  final String ptTable = "_prayer_time_zone";
  final String ptId = "id";
  final String ptCode = "code";
  final String ptState = "state";
  final String ptRegion = "region";
  final String ptIsSelected = "isSelected";

  // for table creation
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

  // get zone list sorted to selected first
  Future<List<PrayerTimeZone>> getList(Database db) async {
    try {
      var onValue = await db.query(ptTable, orderBy: "$ptIsSelected DESC");
      if (onValue.isNotEmpty) {
        return onValue.map((item) => PrayerTimeZone.fromJson(item)).toList();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // get selected zone
  Future<PrayerTimeZone> getSelectedZone(Database db) async {
    try {
      var onValue = await db.query(ptTable, where: '$ptIsSelected=1');
      if (onValue.isNotEmpty) {
        return PrayerTimeZone.fromJson(onValue[0]);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // set selected zone and unselect old selected zone
  Future<ErrorStatusEnum> setSelectedZone(Database db, String code) async {
    // unselect all selected zone
    try {
      db.rawUpdate(
        '''
        UPDATE $ptTable
        SET $ptIsSelected=0
        WHERE $ptIsSelected=1
        ''',
      );
    } catch (e) {
      return ErrorStatusEnum.ERROR;
    }
    // select zone
    try {
      db.rawUpdate(
        '''
        UPDATE $ptTable
        SET $ptIsSelected=1
        WHERE $ptCode=?
        ''',
        [
          code
        ],
      );
    } catch (e) {
      return ErrorStatusEnum.ERROR;
    }
    return ErrorStatusEnum.OK;
  }

  // insert new entry
  Future<ErrorStatusEnum> insert(Database db, Map<String, dynamic> data) async {
    // delete existing
    try {
      db.delete(
        ptTable,
        where: "$ptCode=?",
        whereArgs: [
          data['code'],
        ],
      );
    } catch (e) {
      return ErrorStatusEnum.ERROR;
    }
    // insert new data
    try {
      db.insert(ptTable, data);
    } catch (e) {
      return ErrorStatusEnum.ERROR;
    }
    return ErrorStatusEnum.OK;
  }
}
