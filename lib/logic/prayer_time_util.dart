import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:tuple/tuple.dart';
import 'package:waktuku/logic/common.dart';
import 'package:waktuku/model/prayer_time_data.dart';
import 'package:waktuku/model/prayer_time_zone.dart';

class PrayerTimeUtil {
  // private: get zone list
  static String _urlMain = "https://www.e-solat.gov.my/";
  static Future<Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>> getZoneList() async {
    // get response from url
    List<PrayerTimeZone> returnValues = List<PrayerTimeZone>();
    Response response = await get(_urlMain);
    if (response.statusCode != 200) {
      return Tuple2(ErrorStatusEnum.ERROR, returnValues);
    }
    // parse response (skipped first item due to not exactly a value)
    List<Element> listNode = parse(response.body).querySelectorAll('#inputzone option').toList();
    if (listNode.length == 0) {
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
        case "KLT":
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
        default:
          state = "Wilayah Persekutuan";
      }
      returnValues.add(PrayerTimeZone(code: code.trim(), state: state.trim(), region: region.trim(), isSelected: 0));
    }
    return Tuple2(ErrorStatusEnum.OK, returnValues);
  }

  // private: get zone list
  static String _urlData = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat";
  static Future<Tuple2<ErrorStatusEnum, List<PrayerTimeData>>> getZoneData(String period, String zone) async {
    // get response from url
    List<PrayerTimeData> returnValues = List<PrayerTimeData>();
    Response response = await get(_urlData + "&period=" + period + "&zone=" + zone);
    if (response.statusCode != 200) {
      return Tuple2(ErrorStatusEnum.ERROR, returnValues);
    }
    // parse response (json) and convert them to prayer time data
    if (jsonDecode(response.body.toString())['prayerTime'] == null) {
      return Tuple2(ErrorStatusEnum.ERROR, returnValues);
    }
    returnValues = (jsonDecode(response.body.toString())['prayerTime'] as List).map((item) {
      item['zone'] = zone;
      return PrayerTimeData.fromJson(item);
    }).toList();
    if (returnValues.length == 0) {
      return Tuple2(ErrorStatusEnum.ERROR, returnValues);
    }
    return Tuple2(ErrorStatusEnum.OK, returnValues);
  }
}
