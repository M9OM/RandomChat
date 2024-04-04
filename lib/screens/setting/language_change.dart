import 'package:chatme/constant/str_extntion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../constant/translate_constat.dart';
import '../../provider/DarktModeProvider.dart';

class Language_Change extends StatelessWidget {
  const Language_Change({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<DarktModeProvider>(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(
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
                      TranslationConstants.language.t(context),
                      style: TextStyle(fontSize: 18),
                    ))
                  ]))),
          ListTile(
            leading: Text('العربية'),
            trailing: InkWell(
              onTap: () {
                lang.changeLanguage('ar');
              },
              child: Container(
                  width: 30,
                  height: 30,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: theme.primaryColor, shape: BoxShape.circle),
                  child: lang.locale == 'ar'
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : SizedBox()),
            ),
          ),
          ListTile(
            leading: Text('English'),
            trailing: InkWell(
              onTap: () {
                lang.changeLanguage('en');
              },
              child: Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: theme.primaryColor, shape: BoxShape.circle),
                  child: lang.locale == 'en'
                      ? Icon(Icons.done, color: Colors.white)
                      : SizedBox()),
            ),
          ),
        ],
      ),
    );
  }
}
