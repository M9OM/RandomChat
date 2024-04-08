import 'package:chatme/screens/findToChat/findToChat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class StartChating extends StatefulWidget {
  const StartChating({super.key});

  @override
  State<StartChating> createState() => _StartChatingState();
}

class _StartChatingState extends State<StartChating> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FindToChat()));
        },
        child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('Start Chatting!'),
                            ),
      ),
    ),);
  }
}