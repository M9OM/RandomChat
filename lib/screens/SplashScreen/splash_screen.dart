// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import '../../provider/providerauth.dart';
import '../screachToChat/screach.dart';
import '/services/auth.dart';

import '../chatList/chatList.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
  final user = Provider.of<ModelsProvider>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () async {
                await AuthService().signUp(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserToChat(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 21, 195, 111),
                    borderRadius: BorderRadius.circular(20)),
                child: Text('Start Chating!'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
