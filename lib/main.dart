import 'package:chatme/provider/DarktModeProvider.dart';
import 'package:chatme/provider/providerauth.dart';
import 'package:chatme/screens/registration/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'loc/lang_setup.dart';
import 'screens/ChangeScreens.dart';
import 'screens/SplashScreen/splash_screen.dart';
import 'ui/color.dart';

Future check(context) async {
  await Future.delayed(const Duration(seconds: 3), () {});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
                  debugShowCheckedModeBanner: false,
                supportedLocales: AppLocalizationsSetup.supportedLocales,
            localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,


                  theme: darkModeNotifier.isDarkMode ? darkMode : lightMode,
                  locale: darkModeNotifier.locale,
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
