import 'package:shared_preferences/shared_preferences.dart';

class ThemeSharedPrefs{
  static const String themeStatus = 'themeStatus';

  Future<void> setDarkTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, value);
  }

  Future<bool> getDarkTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeStatus) ?? false;
  }
}