import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferenceEnum {
  SHARED_PREF_HOUR_FORMAT,
}

Map<SharedPreferenceEnum, String> sharedPreferenceEnumMap = {
  SharedPreferenceEnum.SHARED_PREF_HOUR_FORMAT: 'shared_pref_hour_format',
};

Future<bool> sharedPrefIs12HourFormat() async {
  final bool defaultVal = false;
  final SharedPreferences pref = await SharedPreferences.getInstance();
  bool val = pref.getBool(sharedPreferenceEnumMap[SharedPreferenceEnum.SHARED_PREF_HOUR_FORMAT]);
  return (val != null ? val : defaultVal);
}

Future<bool> sharedPrefSet12HourFormat(bool value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setBool(sharedPreferenceEnumMap[SharedPreferenceEnum.SHARED_PREF_HOUR_FORMAT], value);
}
