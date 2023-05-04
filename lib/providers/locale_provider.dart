import 'dart:io';

import 'package:gooddelivary/l10n/l10n.dart';
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  final languagePlatform = Platform.localeName.substring(0, 2);
  Locale get locale => _locale ?? Locale(languagePlatform);

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
