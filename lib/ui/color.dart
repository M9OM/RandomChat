import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/providerauth.dart';
class DarktMode {
  Color highlightColor = Color.fromARGB(255, 160, 115, 236);
  Color mainColor = Color.fromRGBO(143, 47, 253, 1);
  Color iconColor = const Color.fromARGB(255, 213, 213, 213);
  Color backgroundColor = Colors.black;
  Color cardBackground = const Color.fromARGB(255, 38, 38, 38);
  Color bottomColor = const Color(0xFF10133B);
  Color appBarColor = Color.fromARGB(255, 26, 26, 26);
  Color meColor = const Color.fromARGB(255, 38, 38, 38);
  Color otherColor = const Color(0xFFE5CFFF);
}
class LightMode {
  Color highlightColor = Color.fromARGB(255, 160, 115, 236);
  Color mainColor = Color.fromRGBO(183, 119, 255, 1);
  Color iconColor = Colors.black;
  Color backgroundColor = const Color(0xFFE9F3FB);
  Color cardBackground = Colors.white;
  Color bottomColor = const Color(0xFF10133B);
  Color appBarColor = const Color.fromARGB(255, 204, 227, 244);
  Color appBarColorBlack = const Color.fromARGB(255, 0, 0, 0);
  Color meColor = Colors.white;
  Color otherColor = const Color(0xFFE5CFFF);
}

ThemeData lightMode = ThemeData(
  selectedRowColor: LightMode().highlightColor,
  primarySwatch:Colors.purple,
    iconTheme: IconThemeData(color: LightMode().iconColor),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: LightMode().bottomColor),
    scaffoldBackgroundColor: LightMode().backgroundColor,
    primaryColor: LightMode().mainColor,
    cardColor: LightMode().cardBackground,
    appBarTheme: AppBarTheme(backgroundColor: LightMode().appBarColor),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: Colors.black,
          fontFamily: 'Orbitron'), // Set body text color to black
      bodyMedium: TextStyle(color: Colors.black, fontFamily: 'Orbitron'),
    ));

ThemeData darkMode = ThemeData.dark().copyWith(
    selectedRowColor: DarktMode().highlightColor,

    iconTheme: IconThemeData(color: DarktMode().iconColor),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: DarktMode().bottomColor),
    scaffoldBackgroundColor: DarktMode().backgroundColor,
    primaryColor: DarktMode().mainColor,
    cardColor: DarktMode().cardBackground,
    appBarTheme: AppBarTheme(backgroundColor: DarktMode().appBarColor),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: Colors.white,
          fontFamily: 'Orbitron'), // Set body text color to black
      bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Orbitron'),
    ));



EdgeInsetsGeometry padding = const EdgeInsets.all(15);
AlignmentGeometry meAlignment = Alignment.topRight;
AlignmentGeometry aiAlignment = Alignment.topLeft;
BorderRadiusGeometry borderRadiusOther = const BorderRadius.only(
  topRight: Radius.circular(20),
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);
BorderRadiusGeometry borderRadiusMe = const BorderRadius.only(
  topLeft: Radius.circular(20),
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);
