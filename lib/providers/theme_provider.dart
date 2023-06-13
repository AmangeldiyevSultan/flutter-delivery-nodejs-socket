import 'package:flutter/material.dart';
import 'package:gooddelivary/constants/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeType _themeType;
  late MyThemePreferences _preferences;

  ThemeType get themeType => _themeType;

  ThemeProvider() {
    _themeType = ThemeType.light;
    _preferences = MyThemePreferences();
    getPreferences();
  }

  getPreferences() async {
    _themeType = await _preferences.getTheme();
    notifyListeners();
  }

  set themeType(ThemeType themeType) {
    _themeType = themeType;
    _preferences.setTheme(themeType);
    notifyListeners();
  }

  void resetTheme() async {
    _themeType = ThemeType.light;
    _preferences.setTheme(ThemeType.light);
    notifyListeners();
  }
}

class MyThemePreferences {
  static const kThemeKey = "theme";

  setTheme(ThemeType themeType) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(kThemeKey, themeType.name.toString());
  }

  getTheme() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final themeData = sharedPreferences.getString(kThemeKey);
    ThemeType themeType = themeData == 'dark'
        ? ThemeType.dark
        : themeData == 'pink'
            ? ThemeType.pink
            : ThemeType.light;

    return themeType;
  }
}
