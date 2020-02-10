import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:waktuku/logic/common.dart';
import 'package:waktuku/model/prayer_time_data.dart';
import 'package:waktuku/model/prayer_time_zone.dart';

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
    DateTime dateTimeFromString = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('HH:mm').format(dateTimeFromString);
  }

  // get zone list
  static String _urlMain = "https://www.e-solat.gov.my/";
  static Future<Tuple2<ErrorStatusEnum, List<PrayerTimeZone>>> retrieveZoneList() async {
    // get response from url
    List<PrayerTimeZone> returnValues = List<PrayerTimeZone>();
    Response response = await _httpGet(_urlMain).timeout(Duration(seconds: 5));
    if (response == null || response.statusCode != 200) {
      return Tuple2(ErrorStatusEnum.ERROR_UNABLE_REACH_ESOLAT, returnValues);
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

  // retrieve zone list
  static String _urlData = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat";
  static Future<Tuple2<ErrorStatusEnum, List<PrayerTimeData>>> retrieveZoneData(String period, String zone) async {
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
    returnValues = (jsonDecode(response.body.toString())['prayerTime'] as List).map((item) {
      item['zone'] = zone;
      item['imsak'] = _fixTimeFormat(item['imsak']);
      item['fajr'] = _fixTimeFormat(item['fajr']);
      item['syuruk'] = _fixTimeFormat(item['syuruk']);
      item['dhuhr'] = _fixTimeFormat(item['dhuhr']);
      item['asr'] = _fixTimeFormat(item['asr']);
      item['maghrib'] = _fixTimeFormat(item['maghrib']);
      item['isha'] = _fixTimeFormat(item['isha']);
      return PrayerTimeData.fromJson(item);
    }).toList();
    if (returnValues.length == 0) {
      return Tuple2(ErrorStatusEnum.ERROR, returnValues);
    }
    return Tuple2(ErrorStatusEnum.OK, returnValues);
  }

  // fix calendar
  static String fixHijriCalendar(String hijri) {
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
    String fixedHijriDate = hijri.split('-')[2] + ' ' + hijriMonthComplete + ' ' + hijri.split('-')[0] + ' Hijri';

    // return
    return fixedHijriDate;
  }
}
