import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _localeKey = 'app_locale';
  Locale _locale = PlatformDispatcher.instance.locale;

  Locale get locale {

    return _locale;
  }

  LocaleProvider() {
    _loadLocale();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _saveLocale();
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey) ?? _locale.languageCode;
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, _locale.languageCode);
  }
}
