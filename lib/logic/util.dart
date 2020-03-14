import 'package:http/http.dart';
import 'package:intl/intl.dart';

import 'package:minaret/logic/common.dart';

// http get for catching socket exception
Future<Response> httpGet(String url) async {
  try {
    return await get(url);
  } catch (e) {
    return null;
  }
}

// fix time format
String fixTimeFormat(String time) {
  return DateFormat('HH:mm').format(DateFormat('HH:mm:ss').parse(time));
}

// fix calendar
String fixHijriFormat(String hijri) {
  return hijri.split('-')[2] + ' ' + hijriMonthNameMap[hijri.split('-')[1]] + ' ' + hijri.split('-')[0] + ' Hijri';
}
