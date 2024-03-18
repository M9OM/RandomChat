import 'package:chatme/provider/providerauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/SplashScreen/splash_screen.dart';
import '/screens/chatList/chatList.dart';
import '/screens/chat_screen/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key})
      : super(key: key); // Corrected syntax for key parameter

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user; // Declare user without initialization

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    // Initialize user in initState
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModelsProvider>(
      // Specify the type of provider
      create: (_) => ModelsProvider()..setCurrentModel(user!.uid), // Initialize
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
            bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: 'Orbitron'), // Set body text color to black
            bodyText2: TextStyle(color: Colors.white, fontFamily: 'Orbitron'),
            // Set body text color to black
            // Add more text styles here as needed
          ),
        ),
        home: user == null ? const SplashScreen() : const homeScreen(),
      ),
    );
  }
}
