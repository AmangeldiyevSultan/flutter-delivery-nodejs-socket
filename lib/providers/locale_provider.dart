import 'dart:io';

import 'package:gooddelivary/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  late Locale _locale;
  late LocalePreference _localePreference;
  final languagePlatform = Platform.localeName.substring(0, 2);

  Locale get locale => _locale;

  LocaleProvider() {
    _locale = const Locale('kk');
    _localePreference = LocalePreference();
    getLocale();
  }

  getLocale() async {
    _locale = await _localePreference.getLocale();
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    _localePreference.setLocale(locale.languageCode);
    notifyListeners();
  }

  void resetLocale() async {
    _locale = await _localePreference.resetLocale();
    _localePreference.setLocale(_locale.languageCode);

    notifyListeners();
  }
}

class LocalePreference {
  static const kLocalKey = "locale";
  final languagePlatform = Platform.localeName.substring(0, 2);

  setLocale(String locale) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.setString(kLocalKey, locale);
  }

  getLocale() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final localeData =
        sharedPreferences.getString(kLocalKey) ?? languagePlatform;

    return Locale(localeData);
  }

  resetLocale() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setString(kLocalKey, '');

    return Locale(languagePlatform);
  }
}
