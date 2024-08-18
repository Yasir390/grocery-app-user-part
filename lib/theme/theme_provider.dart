import 'package:flutter/material.dart';
import 'package:grocery_app/theme/theme_shared_prefs.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkTheme = false;

  bool get getDarkTheme => _darkTheme;
  ThemeSharedPrefs themeSharedPrefs = ThemeSharedPrefs();

  set setDarkTheme(bool value) {
    _darkTheme = value;
    themeSharedPrefs.setDarkTheme(value);
    notifyListeners();
  }
}