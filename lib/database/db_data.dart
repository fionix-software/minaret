import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:minaret/database/helper.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/model/pt_data.dart';

class DatabaseItemPrayerTime {
  // table information
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

  // for table creation
  Future<ErrorStatusEnum> create(Database db) async {
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
      databaseErrorMessageLog('db_data.create', e);
      return ErrorStatusEnum.ERROR;
    }
    return ErrorStatusEnum.OK;
  }

  // get prayer data from date
  Future<PrayerTimeData> getPrayerDataFromDate(Database db, String zone, DateTime date) async {
    // parse date as Malaysia time format
    await initializeDateFormatting('ms_MY', null);
    String dateStr = DateFormat('dd-MMM-yyyy', 'ms').format(date);
    // get prayer data from date
    try {
      var onValue = await db.query(
        ptTable,
        where: "$ptDate=? AND $ptZone=?",
        whereArgs: [
          dateStr,
          zone,
        ],
      );
      if (onValue != null && onValue.isNotEmpty) {
        return PrayerTimeData.fromJson(onValue[0]);
      }
    } catch (e) {
      databaseErrorMessageLog('db_data.getPrayerDataFromDate', e);
      return null;
    }
    // error
    return null;
  }

  // insert new data and delete old one if exist
  Future<ErrorStatusEnum> insert(Database db, Map<String, dynamic> data) async {
    // delete existing
    try {
      await db.delete(
        ptTable,
        where: "$ptDate=? AND $ptZone=?",
        whereArgs: [
          data['date'],
          data['zone'],
        ],
      );
    } catch (e) {
      databaseErrorMessageLog('db_data.insert.delete', e);
      return ErrorStatusEnum.ERROR;
    }
    // insert new data
    try {
      await db.insert(ptTable, data);
    } catch (e) {
      databaseErrorMessageLog('db_data.insert.insert', e);
      return ErrorStatusEnum.ERROR;
    }
    return ErrorStatusEnum.OK;
  }
}
