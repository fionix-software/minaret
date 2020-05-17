import 'package:shared_preferences/shared_preferences.dart';

/* Theme */

const String SHARED_PREF_THEME = 'shared_pref_theme';
const int THEME_SYSTEM = 0;
const int THEME_LIGHT = 1;
const int THEME_DARK = 2;

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

/* Home screen tutorial */

const String SHARED_PREF_TUTORIAL_HOME = 'shared_pref_tutorial_home';

Future<bool> sharedPrefTutorialHomeScreenIsComplete() async {
  final bool defaultVal = false;
  final SharedPreferences pref = await SharedPreferences.getInstance();
  bool val = pref.getBool(SHARED_PREF_TUTORIAL_HOME);
  return (val != null ? val : defaultVal);
}

Future<bool> sharedPrefTutorialHomeScreenSetComplete() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setBool(SHARED_PREF_TUTORIAL_HOME, true);
}

Future<bool> sharedPrefTutorialHomeScreenResetComplete() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setBool(SHARED_PREF_TUTORIAL_HOME, false);
}
