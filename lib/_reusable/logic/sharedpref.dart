/* Theme */

import 'package:shared_preferences/shared_preferences.dart';

const int THEME_SYSTEM = 0;
const int THEME_LIGHT = 1;
const int THEME_DARK = 2;
const String SHARED_PREF_THEME = 'shared_pref_theme';

Future<int> sharedPrefGetTheme() async {
  final int defaultVal = THEME_SYSTEM;
  final SharedPreferences pref = await SharedPreferences.getInstance();
  int val = pref.getInt(SHARED_PREF_THEME);
  return (val != null ? val : defaultVal);
}

Future<bool> sharedPrefSetTheme(int value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setInt(SHARED_PREF_THEME, value);
}
