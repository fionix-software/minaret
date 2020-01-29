import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:tuple/tuple.dart';
import 'package:waktuku/logic/common.dart';
import 'package:waktuku/model/prayer_time_data.dart';

class PrayerTime {
  // private: get zone list
  String _urlMain = "https://www.e-solat.gov.my/";
  Future<Tuple2<ErrorStatus, List<String>>> _getZoneList() async {
    // get response from url
    List<String> returnValues = List<String>();
    Response response = await get(_urlMain);
    if (response.statusCode != 200) {
      return Tuple2(ErrorStatus.ERROR, returnValues);
    }
    // parse response (skipped first item due to not exactly a value)
    List<Element> listNode = parse(response.body).querySelectorAll('#inputzone option').toList();
    if (listNode.length == 0) {
      return Tuple2(ErrorStatus.ERROR, returnValues);
    }
    for (int i = 1; i < listNode.length; ++i) {
      returnValues.add(listNode.elementAt(i).text);
    }
    return Tuple2(ErrorStatus.OK, returnValues);
  }

  // private: get zone list
  String _urlData = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat";
  Future<Tuple2<ErrorStatus, List<PrayerTimeData>>> _getZoneData(String period, String zone) async {
    // get response from url
    List<PrayerTimeData> returnValues = List<PrayerTimeData>();
    Response response = await get(_urlData + "&period=" + period + "&zone=" + zone);
    if (response.statusCode != 200) {
      return Tuple2(ErrorStatus.ERROR, returnValues);
    }
    // parse response (json) and convert them to prayer time data
    returnValues = (jsonDecode(response.body.toString())['prayerTime'] as List).map((item) {
      item['zone'] = zone;
      return PrayerTimeData.fromJson(item);
    }).toList();
    if (returnValues.length == 0) {
      return Tuple2(ErrorStatus.ERROR, returnValues);
    }
    return Tuple2(ErrorStatus.OK, returnValues);
  }
}
