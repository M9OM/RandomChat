import 'package:chatme/constant/str_extntion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/translate_constat.dart';
import '../../provider/DarktModeProvider.dart';

class Language_Change extends StatelessWidget {
  const Language_Change({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<DataProvider>(context);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title:  Text(
                      TranslationConstants.language.t(context),
                    )),
      body: Column(
        children: [

          ListTile(
            leading: Text(
              'العربية',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: theme.textTheme.bodyMedium!.fontSize),
            ),
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
                          color: theme.scaffoldBackgroundColor,
                        )
                      : SizedBox()),
            ),
          ),
          ListTile(
            leading: Text('English', style: TextStyle(fontWeight: FontWeight.bold,fontSize: theme.textTheme.bodyMedium!.fontSize),
),
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
                      ? Icon(Icons.done, color: theme.scaffoldBackgroundColor)
                      : SizedBox()),
            ),
          ),
        ],
      ),
    );
  }
}
