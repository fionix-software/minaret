import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/prayer_time_database.dart';
import 'package:minaret/logic/prayer_time_database_data.dart';
import 'package:minaret/logic/prayer_time_database_zone.dart';
import 'package:minaret/model/prayer_time_data.dart';
import 'package:minaret/model/prayer_time_zone.dart';

class PrayerTimeUtil {
  // http get for catching socket exception
  static Future<Response> _httpGet(String url) async {
    try {
      return await get(url);
    } catch (e) {
      return null;
    }
  }

  // fix time format
  static String _fixTimeFormat(String time) {
    return DateFormat('HH:mm').format(DateFormat('HH:mm:ss').parse(time));
  }

  // fix calendar
  static String _fixHijriFormat(String hijri) {
    String hijriMonth = hijri.split('-')[1];
    String hijriMonthComplete;
    switch (hijriMonth) {
      case '02':
        hijriMonthComplete = "Safar";
        break;
      case '03':
        hijriMonthComplete = "Rabi'ulawal";
        break;
      case '04':
        hijriMonthComplete = "Rabi'ulakhir";
        break;
      case '05':
        hijriMonthComplete = "Jamadilawwal";
        break;
      case '06':
        hijriMonthComplete = "Jamadilakhir";
        break;
      case '07':
        hijriMonthComplete = "Rejab";
        break;
      case '08':
        hijriMonthComplete = "Sya'ban";
        break;
      case '09':
        hijriMonthComplete = "Ramadhan";
        break;
      case '10':
        hijriMonthComplete = "Shawwal";
        break;
      case '11':
        hijriMonthComplete = "Zulqa'idah";
        break;
      case '12':
        hijriMonthComplete = "Zulhijjah";
        break;
      default:
        hijriMonthComplete = "Muharram";
    }
    return hijri.split('-')[2] + ' ' + hijriMonthComplete + ' ' + hijri.split('-')[0] + ' Hijri';
  }

  // get zone list
  static String _urlMain = "https://www.e-solat.gov.my/";
  static Future<Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>> _retrieveZoneList() async {
    // get response from url
    List<PrayerTimeZone> returnValues = List<PrayerTimeZone>();
    Response response = await _httpGet(_urlMain).timeout(Duration(seconds: 5));
    if (response == null || response.statusCode != 200) {
      return Tuple2(ErrorStatusEnum.ERROR_UNABLE_REACH_ESOLAT, returnValues);
    }

    // parse response (skipped first item due to not exactly a value)
    List<Element> listNode = parse(response.body).querySelectorAll('#inputzone option').toList();
    if (listNode.length <= 1) {
      return Tuple2(ErrorStatusEnum.ERROR, returnValues);
    }
    for (int i = 1; i < listNode.length; ++i) {
      String code = listNode.elementAt(i).text.split("-").elementAt(0);
      String region = listNode.elementAt(i).text.split("-").elementAt(1);
      String state;
      switch (code.substring(0, 3)) {
        case "JHR":
          state = "Johor";
          break;
        case "KDH":
          state = "Kedah";
          break;
        case "KTN":
          state = "Kelantan";
          break;
        case "MLK":
          state = "Melaka";
          break;
        case "NGS":
          state = "Negeri Sembilan";
          break;
        case "PHG":
          state = "Pahang";
          break;
        case "PLS":
          state = "Perlis";
          break;
        case "PNG":
          state = "Pulau Pinang";
          break;
        case "PRK":
          state = "Perak";
          break;
        case "SBH":
          state = "Sabah";
          break;
        case "SGR":
          state = "Selangor";
          break;
        case "SWK":
          state = "Sarawak";
          break;
        case "TRG":
          state = "Terengganu";
          break;
        case "WLY":
          state = "Wilayah Persekutuan";
          break;
        default:
          state = "Unknown";
      }
      returnValues.add(PrayerTimeZone(code: code.trim(), state: state.trim(), region: region.trim(), isSelected: 0));
    }
    return Tuple2(ErrorStatusEnum.OK, returnValues);
  }

  // retrieve zone list
  static String _urlData = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat";
  static Future<Tuple2<ErrorStatusEnum, List<PrayerTimeData>>> _retrieveZoneData(String period, String zone) async {
    // get response from url
    List<PrayerTimeData> returnValues = List<PrayerTimeData>();
    Response response = await _httpGet(_urlData + "&period=" + period + "&zone=" + zone).timeout(Duration(seconds: 5));
    if (response == null || response.statusCode != 200) {
      return Tuple2(ErrorStatusEnum.ERROR_UNABLE_REACH_ESOLAT, returnValues);
    }
    // parse response (json) and convert them to prayer time data
    if (jsonDecode(response.body.toString())['prayerTime'] == null) {
      return Tuple2(ErrorStatusEnum.ERROR, returnValues);
    }
    returnValues = (jsonDecode(response.body.toString())['prayerTime'] as List).map(
      (item) {
        item['zone'] = zone;
        item['hijri'] = _fixHijriFormat(item['hijri']);
        item['imsak'] = _fixTimeFormat(item['imsak']);
        item['fajr'] = _fixTimeFormat(item['fajr']);
        item['syuruk'] = _fixTimeFormat(item['syuruk']);
        item['dhuhr'] = _fixTimeFormat(item['dhuhr']);
        item['asr'] = _fixTimeFormat(item['asr']);
        item['maghrib'] = _fixTimeFormat(item['maghrib']);
        item['isha'] = _fixTimeFormat(item['isha']);
        return PrayerTimeData.fromJson(item);
      },
    ).toList();
    // check list length
    if (returnValues.length == 0) {
      return Tuple2(ErrorStatusEnum.ERROR, returnValues);
    }
    return Tuple2(ErrorStatusEnum.OK, returnValues);
  }

  // check prayer data status
  static Future<ErrorStatusEnum> checkPrayerDataStatus() async {
    // get zone list
    var getZoneListReturn = await DatabaseItemPrayerZone().getList(await DatabaseHelper.getInstance.database);
    if (getZoneListReturn.item1 != ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_GET_ZONE_LIST;
    }
    List<PrayerTimeZone> zoneList = getZoneListReturn.item2;
    // initialize zone list
    if (zoneList.isEmpty) {
      // fetch data
      var retrieveZoneListReturn = await _retrieveZoneList();
      if (retrieveZoneListReturn.item1 != ErrorStatusEnum.OK) {
        return retrieveZoneListReturn.item1;
      } else if (retrieveZoneListReturn.item2.isEmpty) {
        return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST;
      }
      // add data into database
      zoneList = retrieveZoneListReturn.item2;
      zoneList.forEach((item) async {
        DatabaseItemPrayerZone().insert(await DatabaseHelper.getInstance.database, item.toMap());
      });
    }
    // get selected zone
    var getSelectedZoneReturn =
        await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
    if (getSelectedZoneReturn.item1 != ErrorStatusEnum.OK || getSelectedZoneReturn.item2 == null) {
      return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE;
    }
    PrayerTimeZone selectedZone = getSelectedZoneReturn.item2;
    // get current selected zone data
    var getPrayerDataFromTodayReturn = await DatabaseItemPrayerTime()
        .getPrayerDataFromDate(await DatabaseHelper.getInstance.database, selectedZone.code, DateTime.now());
    if (getPrayerDataFromTodayReturn.item1 != ErrorStatusEnum.OK) {
      return getSelectedZoneReturn.item1;
    }
    // intialize zone data
    if (getPrayerDataFromTodayReturn.item2 == null) {
      // retrieve zone data
      var retrieveSelectedZoneDataReturn = await _retrieveZoneData('year', selectedZone.code);
      if (retrieveSelectedZoneDataReturn.item1 != ErrorStatusEnum.OK) {
        return retrieveSelectedZoneDataReturn.item1;
      } else if (retrieveSelectedZoneDataReturn.item2.isEmpty) {
        return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA;
      }
      // add data into database
      retrieveSelectedZoneDataReturn.item2.forEach((item) async {
        DatabaseItemPrayerTime().insert(await DatabaseHelper.getInstance.database, item.toMap());
      });
      // get the zone data after retrieve
      getPrayerDataFromTodayReturn = await DatabaseItemPrayerTime()
          .getPrayerDataFromDate(await DatabaseHelper.getInstance.database, selectedZone.code, DateTime.now());
      if (getPrayerDataFromTodayReturn.item1 != ErrorStatusEnum.OK) {
        return getPrayerDataFromTodayReturn.item1;
      } else if (getPrayerDataFromTodayReturn.item2 == null) {
        return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA;
      }
    }
    // finished
    return ErrorStatusEnum.OK;
  }

  // set selected zone
  static Future<ErrorStatusEnum> setSelectedZone(String zone) async {
    // retrieve zone data
    var retrieveSelectedZoneDataReturn = await _retrieveZoneData('year', zone);
    if (retrieveSelectedZoneDataReturn.item1 != ErrorStatusEnum.OK) {
      return retrieveSelectedZoneDataReturn.item1;
    } else if (retrieveSelectedZoneDataReturn.item2.isEmpty) {
      return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA;
    }
    // add data into database
    retrieveSelectedZoneDataReturn.item2.forEach((item) async {
      DatabaseItemPrayerTime().insert(await DatabaseHelper.getInstance.database, item.toMap());
    });
    // set selected zone
    if (await DatabaseItemPrayerZone().setSelectedZone(await DatabaseHelper.getInstance.database, zone) !=
        ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_SET_SELECTED_ZONE;
    }
    return ErrorStatusEnum.OK;
  }

  // get prayer time data
  static Future<Tuple3<PrayerTimeZone, PrayerTimeData, ErrorStatusEnum>> getPrayerTimeData() async {
    // get selected zone
    var getSelectedZoneReturn =
        await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
    if (getSelectedZoneReturn.item1 != ErrorStatusEnum.OK) {
      return Tuple3(null, null, getSelectedZoneReturn.item1);
    } else if (getSelectedZoneReturn.item2 == null) {
      return Tuple3(null, null, ErrorStatusEnum.ERROR_GET_SELECTED_ZONE);
    }
    PrayerTimeZone selectedZone = getSelectedZoneReturn.item2;
    // get current selected zone data
    var getPrayerDataFromTodayReturn = await DatabaseItemPrayerTime()
        .getPrayerDataFromDate(await DatabaseHelper.getInstance.database, selectedZone.code, DateTime.now());
    if (getPrayerDataFromTodayReturn.item1 != ErrorStatusEnum.OK) {
      return Tuple3(selectedZone, null, getPrayerDataFromTodayReturn.item1);
    } else if (getPrayerDataFromTodayReturn.item2 == null) {
      return Tuple3(selectedZone, null, ErrorStatusEnum.ERROR_GET_SELECTED_ZONE_DATA);
    }
    PrayerTimeData selectedZoneData = getPrayerDataFromTodayReturn.item2;
    // fix date and return
    selectedZoneData.date = DateFormat('dd MMMM yyyy').format(DateFormat('dd-MMM-yyyy').parse(selectedZoneData.date));
    return Tuple3(selectedZone, selectedZoneData, ErrorStatusEnum.OK);
  }

  // update existing prayer zone data
  static Future<ErrorStatusEnum> updateData() async {
    // get selected zone
    var getSelectedZoneReturn =
        await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
    if (getSelectedZoneReturn.item1 != ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_GET_SELECTED_ZONE;
    }
    PrayerTimeZone selectedZone = getSelectedZoneReturn.item2;
    // retrieve zone data
    var retrieveSelectedZoneDataReturn = await _retrieveZoneData('year', selectedZone.code);
    if (retrieveSelectedZoneDataReturn.item1 != ErrorStatusEnum.OK) {
      return retrieveSelectedZoneDataReturn.item1;
    } else if (retrieveSelectedZoneDataReturn.item2.isEmpty) {
      return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA;
    }
    // add data into database
    retrieveSelectedZoneDataReturn.item2.forEach((item) async {
      DatabaseItemPrayerTime().insert(await DatabaseHelper.getInstance.database, item.toMap());
    });
    return ErrorStatusEnum.OK;
  }
}
