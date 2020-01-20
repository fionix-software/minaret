import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';

// urls
String urlMain = "https://www.e-solat.gov.my/";
String urlJson = "https://www.e-solat.gov.my/index.php?r=esolatApi/takwimsolat&period=year";

// get list of zones
Future<List<String>> getZoneList() async {
  Response response = await get(urlMain);
  Document doc = parse(response.body);
  List<Element> listNode = doc.querySelectorAll('#inputzone option').toList();
  List<String> returnValues = List<String>();
  // skipped first item due to not exactly a value
  for (var i = 1; i < listNode.length; i++) {
    returnValues.add(listNode.elementAt(i).text);
  }
  return returnValues;
}

// get prayer time data based on zone
Future<String> getZoneData(String zone) async {
  var response = await post(urlJson + "&zone=" + zone);
  return response.body.toString();
}
