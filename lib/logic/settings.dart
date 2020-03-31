import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferenceEnum {
  SHARED_PREF_HOUR_FORMAT,
  SHARED_PREF_THEME,
}

Map<SharedPreferenceEnum, String> sharedPreferenceEnumMap = {
  SharedPreferenceEnum.SHARED_PREF_HOUR_FORMAT: 'shared_pref_hour_format',
  SharedPreferenceEnum.SHARED_PREF_THEME: 'shared_pref_theme',
};

/* Hour format */

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

/* Theme */

const int THEME_SYSTEM = 0;
const int THEME_LIGHT = 1;
const int THEME_DARK = 2;

Future<int> sharedPrefGetTheme() async {
  final int defaultVal = THEME_SYSTEM;
  final SharedPreferences pref = await SharedPreferences.getInstance();
  int val = pref.getInt(sharedPreferenceEnumMap[SharedPreferenceEnum.SHARED_PREF_THEME]);
  return (val != null ? val : defaultVal);
}

Future<bool> sharedPrefSetTheme(int value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setInt(sharedPreferenceEnumMap[SharedPreferenceEnum.SHARED_PREF_THEME], value);
}
