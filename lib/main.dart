import 'dart:convert';

import 'package:chatme/provider/DarktModeProvider.dart';
import 'package:chatme/provider/providerauth.dart';
import 'package:chatme/screens/findToChat/loading.dart';
import 'package:chatme/screens/registration/register_screen.dart';
import 'package:chatme/services/firebaseService.dart';
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

Future<void> check(context) async {
  await Future.delayed(const Duration(seconds: 3), () {});
}

Future<void> loadArabicValue() async {
  final jsonString = await rootBundle.loadString('assets/languages/ar.json');
  arabicJson = json.decode(jsonString) as Map<String, dynamic>;
}

Future<void> loadEnglishValue() async {
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
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  bool loading = true;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        loading = false;
      });
    });
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: null, // Ensure to provide a valid stream here
      builder: (context, snapshot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ModelsProvider>(
              create: (_) => ModelsProvider()..setCurrentModel(user?.uid ?? ''),
            ),
            ChangeNotifierProvider<DataProvider>(
              create: (_) {
                DataProvider provider = DataProvider();

                // Fetch admin data from Firestore using the provided uid
                if (user != null) {
                  getUserData(user!.uid).then((documentSnapshot) {
                    if (documentSnapshot.exists) {
                      // Extract admin data
                      Map<String, dynamic>? adminData = documentSnapshot.data();
                      String? avatarUrl = adminData?['photoURL'];
                      String? name = adminData?['displayName'];
                      String? email = adminData?['email'];
                      List<dynamic>? interest = adminData?['interest'];
                      print(interest);
                      print(email);
                      // Check for null values before passing data to the provider method
                      if (avatarUrl != null &&
                          name != null &&
                          email != null &&
                          interest != null) {
                        provider.userInfoAdmin(
                            avatarUrl, name, email, interest.cast<String>());
                        provider.loadDataApp();
                      }
                    }
                  });
                }

                // Load app data

                return provider;
              },
            ),
          ],
          child: Consumer<DataProvider>(
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
      },
    );
  }
}
