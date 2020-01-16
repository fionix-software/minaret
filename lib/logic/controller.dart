import 'package:http/http.dart';

class PrayerTimeController {
  // field
  String url =
      "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&period=year";
  // method
  Future<String> getZoneData(String zone) async {
    var response = await post(url + "&zone=" + zone);
    return response.body.toString();
  }
}
