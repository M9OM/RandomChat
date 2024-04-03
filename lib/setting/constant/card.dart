import 'package:chatme/constant/assets_constants.dart';
import 'package:chatme/constant/str_extntion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../constant/translate_constat.dart';
import '../../provider/DarktModeProvider.dart';
import '../constant/adminCard.dart';
import '../language_change.dart';
class Card_Setting extends StatelessWidget {
   Card_Setting({super.key, required this.title,required this.admin, required this.details});
String title;
bool admin;
List <ListView> details;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    final darktMode = Provider.of<DarktModeProvider>(context);
    final lang = Provider.of<DarktModeProvider>(context);

    return admin? AdminCard():Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: screenWidth * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: theme.cardColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
             Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
            ),
            Column(
              children: [


                
                ListTile(
                  leading: SvgPicture.asset(
                    AssetsConstants.dark,
                    width: 22,
                    color: theme.iconTheme.color,
                  ),
                  title:  Text(
                      TranslationConstants.darkMode.t(context),
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing: Switch(
                    value: darktMode.isDarkMode,
                    activeColor: theme.primaryColor,
                    onChanged: (value) {
                      darktMode.isDarkMode
                          ? darktMode.toggleDarkMode(false)
                          : darktMode.toggleDarkMode(true);
                    },
                  ),
                ),

                Container(decoration: BoxDecoration(border: Border.all(width: 1,color: theme.dividerColor)),),
                ListTile(
                    leading: SvgPicture.asset(
                      AssetsConstants.notifictionIcon,
                      width: 22,
                      color: theme.iconTheme.color,
                    ),
                    title:  Text(
                      TranslationConstants.notifiction.t(context),
                      style: TextStyle(fontSize: 15),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios)),
                                    Container(decoration: BoxDecoration(border: Border.all(width: 1,color: theme.dividerColor)),),

                ListTile(
                    leading: SvgPicture.asset(
                      AssetsConstants.language,
                      width: 22,
                      color: theme.iconTheme.color,
                    ),
                    title:  Text(
                      TranslationConstants.language.t(context),
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Language_Change(),));
                    },
                    subtitle: lang.locale =='en'? Text('(English)'):Text('(العربية)'),
                    trailing: const Icon(Icons.arrow_forward_ios)),

                    
              ],
            )
          ],
        ),
      ),
    );
  }
}
