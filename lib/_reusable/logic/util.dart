import 'package:http/http.dart';

// http get for catching socket exception
Future<Response> httpGet(String url) async {
  if (url == null || url.isEmpty) {
    return null;
  }
  try {
    return await get(url);
  } catch (e) {
    return null;
  }
}
