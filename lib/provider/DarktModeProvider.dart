import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider with ChangeNotifier {
  String get locale => _locale;
  String _locale = 'en';
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  String get avatarUrl => _avatarUrl;
  String _avatarUrl = '';

  String get name => _name;
  String _name = '';

  String get email => _email;
  String _email = '';

  List<String> get interest => _interest;
  List<String> _interest =[];

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

Future<void> loadDataApp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _locale = prefs.getString('lang') ?? ''; // Use null-aware operator (??) to provide a default value
  _avatarUrl = prefs.getString('avatarUrl') ?? ''; // Use null-aware operator (??) to provide a default value
  _email = prefs.getString('email') ?? ''; // Use null-aware operator (??) to provide a default value
  _name = prefs.getString('displayName') ?? '';
  _interest = prefs.getStringList('interest') ?? []; // Use null-aware operator (??) to provide a default value

  _isDarkMode = prefs.getBool('isDarkMode') ?? false;

  notifyListeners();
}

  void changeLanguage(String newLocale) async {
    _locale = newLocale;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', newLocale);

    notifyListeners();
  }

  void userInfoAdmin(String? avatarUrl, String? name, String? email, List<String>? interest) async {
    
    
    if(avatarUrl !=null && interest !=null && name !=null && email !=null ){

    _avatarUrl = avatarUrl;
    _name = name;
    _email = email;
    _interest = interest;

    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    avatarUrl != null ? await prefs.setString('avatarUrl', avatarUrl) : null;
    name != null
        ? await prefs.setString(
            'displayName',
            name,
          )
        : null;
    email != null
        ? await prefs.setString(
            'email',
            email,
          )
        : null;


        interest != null? await prefs.setStringList('interest', interest):null;

    notifyListeners();
  }

  //   Future<void> loadLang() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _locale = prefs.getString('lang')!;
  //   notifyListeners();
  // }
}
