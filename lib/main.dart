import 'dart:convert';

import 'package:chatme/provider/DarktModeProvider.dart';
import 'package:chatme/provider/providerauth.dart';
import 'package:chatme/screens/findToChat/loading.dart';
import 'package:chatme/screens/registration/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
 import 'package:flutter_localizations/flutter_localizations.dart';
 
 import 'app_localizations.dart';
import 'loc/lang_setup.dart';
import 'screens/ChangeScreens.dart';
import 'screens/SplashScreen/splash_screen.dart';
import 'ui/color.dart';
dynamic arabicJson;
dynamic englishJson;
dynamic local;

Future check(context) async {
  await Future.delayed(const Duration(seconds: 3), () {});
}
 loadArabicValue() async {
    final jsonString = await rootBundle.loadString('assets/languages/ar.json');
    arabicJson = json.decode(jsonString) as Map<String, dynamic>;
  }

  loadEnglishValue() async {
    final jsonString = await rootBundle.loadString('assets/languages/en.json');
    englishJson = json.decode(jsonString) as Map<String, dynamic>;
  }
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await loadEnglishValue();
  await loadArabicValue();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key})
      : super(key: key); // Corrected syntax for key parameter

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  bool isSign = false;
  String userID = '';
  bool loading = true;
  dynamic local;

 

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    // Initialize user in initState
  }

  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelsProvider>(
                create: (_) =>
                    ModelsProvider()..setCurrentModel(user?.uid ?? ''),
              ),
              ChangeNotifierProvider<DarktModeProvider>(
                create: (_) => DarktModeProvider()..loadDarkMode(),
              ),
            



            ],
            child: Consumer<DarktModeProvider>(
              builder: (context, darkModeNotifier, _) {


                return MaterialApp(
                  darkTheme: darkMode,
                  themeMode: darkModeNotifier.isDarkMode
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  debugShowCheckedModeBanner: false,
                              localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  theme: lightMode,
                  locale: Locale(darkModeNotifier.locale),
                  home: loading
                      ? const SplashScreen()
                      : user == null
                          ? const register_screen()
                          : const ChangeScreen(),
                );
              },
            ),
          );
        });
  }
}
