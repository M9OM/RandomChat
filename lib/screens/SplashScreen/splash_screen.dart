import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
backgroundColor: Theme.of(context).bottomAppBarTheme.color,
body: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),),

    );
  }
}