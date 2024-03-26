


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarktModeProvider with ChangeNotifier {
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
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

}
