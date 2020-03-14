import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:minaret/database/db_data.dart';
import 'package:minaret/database/db_zone.dart';
import 'package:minaret/database/helper.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/util.dart';
import 'package:minaret/model/pt_data.dart';
import 'package:minaret/model/pt_zone.dart';

class ESolatRepository {
  // retrieve zone ;ist
  Future<ErrorStatusEnum> retrieveZoneList() async {
    // retrive zone list
    var retrieveZoneListReturn = await _retrieveZoneList();
    if (retrieveZoneListReturn == null || retrieveZoneListReturn.isEmpty) {
      return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_LIST;
    }
    // save into database
    retrieveZoneListReturn.forEach((item) async {
      await DatabaseItemPrayerZone().insert(await DatabaseHelper.getInstance.database, item.toMap());
    });
    // return
    return ErrorStatusEnum.OK;
  }

  // retrieve zone data
  Future<ErrorStatusEnum> retrieveZoneData(String zoneCode) async {
    // retrieve zone data
    var retrieveZoneDataReturn = await _retrieveZoneDataList(zoneCode);
    if (retrieveZoneDataReturn.isEmpty || retrieveZoneDataReturn == null) {
      return ErrorStatusEnum.ERROR_RETRIEVE_ZONE_DATA;
    }
    // save into database
    retrieveZoneDataReturn.forEach((item) async {
      await DatabaseItemPrayerTime().insert(await DatabaseHelper.getInstance.database, item.toMap());
    });
    // return
    return ErrorStatusEnum.OK;
  }

  Future<List<PrayerTimeZone>> getZoneList() async {
    // get zone list
    var getZoneListReturn = await DatabaseItemPrayerZone().getList(await DatabaseHelper.getInstance.database);
    if (getZoneListReturn == null || getZoneListReturn.isEmpty) {
      return null;
    }
    // validated
    return getZoneListReturn;
  }

  Future<PrayerTimeZone> getSelectedZone() async {
    // get selected zone
    var getSelectedZoneReturn = await DatabaseItemPrayerZone().getSelectedZone(await DatabaseHelper.getInstance.database);
    if (getSelectedZoneReturn == null) {
      return null;
    }
    return getSelectedZoneReturn;
  }

  // set zone
  Future<ErrorStatusEnum> setSelectedZone(String zone) async {
    // set selected zone
    ErrorStatusEnum setSelectedZoneReturn = await DatabaseItemPrayerZone().setSelectedZone(await DatabaseHelper.getInstance.database, zone);
    if (setSelectedZoneReturn != ErrorStatusEnum.OK) {
      return ErrorStatusEnum.ERROR_SET_SELECTED_ZONE;
    }
    return ErrorStatusEnum.OK;
  }

  // get prayer time
  Future<PrayerTimeData> getSelectedZoneData(String zone) async {
    // get selected zone data
    var getSelectedZoneDataReturn = await DatabaseItemPrayerTime().getPrayerDataFromDate(await DatabaseHelper.getInstance.database, zone, DateTime.now());
    if (getSelectedZoneDataReturn == null) {
      return null;
    }
    return getSelectedZoneDataReturn;
  }

  // retrieve zone list
  String _urlMain = "https://www.e-solat.gov.my/";
  Future<List<PrayerTimeZone>> _retrieveZoneList() async {
    // get response from url
    Response response = await httpGet(_urlMain).timeout(Duration(seconds: 5));
    if (response == null || response.statusCode != 200) {
      return null;
    }
    // parse response (skipped first item - not a value)
    List<Element> listNode = parse(response.body).querySelectorAll('#inputzone option').toList();
    if (listNode.length <= 1) {
      return null;
    }
    // sanitize result
    List<PrayerTimeZone> returnValues = List<PrayerTimeZone>();
    for (int i = 1; i < listNode.length; ++i) {
      String code = listNode.elementAt(i).text.split("-").elementAt(0).trim();
      String region = listNode.elementAt(i).text.split("-").elementAt(1).trim();
      String state = zoneCodeToStateMap[code.substring(0, 3)].trim();
      returnValues.add(PrayerTimeZone(code: code, state: state, region: region, isSelected: 0));
    }
    // return
    if (returnValues.isEmpty) {
      return null;
    }
    return returnValues;
  }

  // retrieve zone list
  String _urlData = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat";
  Future<List<PrayerTimeData>> _retrieveZoneDataList(String zone) async {
    // get response from url
    Response response = await httpGet(_urlData + "&period=year&zone=" + zone).timeout(Duration(seconds: 5));
    if (response == null || response.statusCode != 200 || jsonDecode(response.body.toString())['prayerTime'] == null) {
      return null;
    }
    // sanitize result
    List<PrayerTimeData> returnValues = List<PrayerTimeData>();
    returnValues = (jsonDecode(response.body.toString())['prayerTime'] as List).map(
      (item) {
        item['zone'] = zone;
        item['hijri'] = fixHijriFormat(item['hijri']);
        item['imsak'] = fixTimeFormat(item['imsak']);
        item['fajr'] = fixTimeFormat(item['fajr']);
        item['syuruk'] = fixTimeFormat(item['syuruk']);
        item['dhuhr'] = fixTimeFormat(item['dhuhr']);
        item['asr'] = fixTimeFormat(item['asr']);
        item['maghrib'] = fixTimeFormat(item['maghrib']);
        item['isha'] = fixTimeFormat(item['isha']);
        return PrayerTimeData.fromJson(item);
      },
    ).toList();
    // return
    if (returnValues.isEmpty) {
      return null;
    }
    return returnValues;
  }
}
