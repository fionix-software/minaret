import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:minaret/logic/common.dart';
import 'package:minaret/logic/util.dart';
import 'package:minaret/model/pt_data.dart';
import 'package:minaret/model/pt_zone.dart';

class ESolatRepository {
  // retrieve zone list
  static String _urlMain = "https://www.e-solat.gov.my/";
  static Future<List<PrayerTimeZone>> retrieveZoneList() async {
    // get response from url
    Response response;
    try {
      response = await httpGet(_urlMain).timeout(Duration(seconds: 5));
    } catch (e) {
      // timeout
      return null;
    }
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
      returnValues.add(PrayerTimeZone(
        zoneCode: code,
        zoneState: state,
        zoneRegion: region,
      ));
    }
    // return
    if (returnValues.isEmpty) {
      return null;
    }
    return returnValues;
  }

  // retrieve zone list
  static String _urlData = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat";
  static Future<List<PrayerTimeData>> retrieveZoneDataList(PrayerTimeZone zone) async {
    // get response from url
    Response response;
    try {
      response = await httpGet(_urlData + "&period=year&zone=" + zone.zoneCode).timeout(Duration(seconds: 5));
    } catch (e) {
      // after timeout
      return null;
    }
    if (response == null || response.statusCode != 200 || jsonDecode(response.body.toString())['prayerTime'] == null) {
      return null;
    }
    // initialize locale data
    await initializeDateFormatting('ms_MY', null);
    // sanitize result
    List<PrayerTimeData> returnValues = List<PrayerTimeData>();
    returnValues = (jsonDecode(response.body.toString())['prayerTime'] as List).map(
      (item) {
        item['zoneCode'] = zone.zoneCode;
        item['zoneState'] = zone.zoneState;
        item['zoneRegion'] = zone.zoneRegion;
        item['date'] = fixDateFormat(item['date']);
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
