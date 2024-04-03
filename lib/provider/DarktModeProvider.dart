import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarktModeProvider with ChangeNotifier {
  String get locale => _locale;
  String _locale = 'en';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
        SharedPreferences prefslang = await SharedPreferences.getInstance();
    _locale = prefslang.getString('lang')!;

    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void changeLanguage(String newLocale) async{
    _locale = newLocale;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', newLocale);

    notifyListeners();
  }
  //   Future<void> loadLang() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _locale = prefs.getString('lang')!;
  //   notifyListeners();
  // }
}
