import 'package:flutter/cupertino.dart';

class L10n {
  static final all = {
    const Locale('en'),
    const Locale('ru'),
    const Locale('kk'),
  };

  static String getFlag(String code) {
    switch (code) {
      case "ru":
        return '🇷🇺';
      case "kk":
        return "🇰🇿";
      case "en":
      default:
        return '🇺🇸';
    }
  }
}
