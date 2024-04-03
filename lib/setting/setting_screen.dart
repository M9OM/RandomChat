import 'package:chatme/constant/str_extntion.dart';
import 'package:chatme/models/setting_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../constant/translate_constat.dart';
import '../provider/DarktModeProvider.dart';
import 'constant/adminCard.dart';
import 'constant/card.dart';

class Settings_Screen extends StatelessWidget {
  const Settings_Screen({super.key});

  @override
  Widget build(BuildContext context) {
        final lang = Provider.of<DarktModeProvider>(context);

    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                      ],
                    ),
                    Center(
                        child: Text(
                      TranslationConstants.setting.t(context),
                      style: TextStyle(fontSize: 18),
                    ))
                  ]))),
          Expanded(
            child: ListView.builder(
              itemCount: cardList.length,
              itemBuilder: (context, index) {
                return cardList[index];
              },
            ),
          ),
        ],
      )),
    );
  }
}
