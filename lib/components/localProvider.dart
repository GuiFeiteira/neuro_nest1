import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('pt');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    _saveLocale(locale);
    notifyListeners();
  }

  Future<void> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? localeCode = prefs.getString('locale');
    if (localeCode != null) {
      _locale = Locale(localeCode);
      notifyListeners();
    }
  }

  Future<void> _saveLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', locale.languageCode);
  }
}
