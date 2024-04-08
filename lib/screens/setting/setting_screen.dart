import 'package:chatme/constant/assets_constants.dart';
import 'package:chatme/constant/str_extntion.dart';
import 'package:chatme/models/setting_models.dart';
import 'package:chatme/provider/providerauth.dart';
import 'package:chatme/screens/setting/constant/detils_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../services/firebaseService.dart';
import '../../services/google_auth.dart';
import '../../widgets/dilog.dart';
import '../Account/AccountInfo_screen.dart';
import '../../constant/translate_constat.dart';
import '../../provider/DarktModeProvider.dart';
import '../registration/register_screen.dart';
import 'constant/adminCard.dart';
import 'constant/card.dart';
import 'language_change.dart';

class Settings_Screen extends StatelessWidget {
  const Settings_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<DataProvider>(context);
    final darktMode = Provider.of<DataProvider>(context);
    final user = Provider.of<ModelsProvider>(context);

    var theme = Theme.of(context);
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
            child: ListView(
              children: [
                Card_Setting(admin: true, title: '', details: []),
                Card_Setting(
                  admin: false,
                  title: TranslationConstants.application.t(context),
                  details: [
                    Details_SettingCard(
                      iSswitch: true,
                      iconSvg: AssetsConstants.dark,
                      title: TranslationConstants.darkMode.t(context),
                      onTap: () {
                        darktMode.isDarkMode
                            ? darktMode.toggleDarkMode(false)
                            : darktMode.toggleDarkMode(true);
                      },
                    ),
                    Details_SettingCard(
                      iSswitch: false,
                      title: TranslationConstants.notifiction.t(context),
                      onTap: () {},
                      iconSvg: AssetsConstants.notifictionIcon,
                    ),
                    Details_SettingCard(
                      iSswitch: false,
                      title: TranslationConstants.language.t(context),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Language_Change(),
                            ));
                      },
                      subtitle: lang.locale == 'en' ? '(English)' : '(العربية)',
                      iconSvg: AssetsConstants.language,
                    ),
                  ],
                ),
                Card_Setting(
                  admin: false,
                  title: TranslationConstants.account.t(context),
                  details: [
                    Details_SettingCard(
                      iSswitch: false,
                      title: TranslationConstants.account_Info.t(context),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountScreen(),
                            ));
                      },
                      iconSvg: AssetsConstants.user,
                    ),
                    Details_SettingCard(
                      iSswitch: false,
                      title: TranslationConstants.upgrade_account.t(context),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const Language_Change(),
                        //     ));
                      },
                      iconSvg: AssetsConstants.gem,
                    ),
                    Details_SettingCard(
                      iSswitch: false,
                      title: TranslationConstants.disable_account.t(context),
                      onTap: () {
                        sendEmail();

                        dialogBuilder(context, onTap: () async {
                          await AuthServices.signOut();
                          user.setCurrentModel('');
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const register_screen(),
                            ),
                            (Route<dynamic> route) =>
                                false, // This predicate always returns false, so it will remove all routes
                          );
                        },
                            text: TranslationConstants.disable_account_msg
                                .t(context));
                      },
                      iconSvg: AssetsConstants.heartCrack,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

// ListTile(
//   leading: SvgPicture.asset(
//     AssetsConstants.dark,
//     width: 22,
//     color: theme.iconTheme.color,
//   ),
//   title: Text(
//     TranslationConstants.darkMode.t(context),
//     style: TextStyle(fontSize: 15),
//   ),
//   trailing: Switch(
//     value: darktMode.isDarkMode,
//     activeColor: theme.primaryColor,
//     onChanged: (value) {
//       darktMode.isDarkMode
//           ? darktMode.toggleDarkMode(false)
//           : darktMode.toggleDarkMode(true);
//     },
//   ),
// ),
// ListTile(
//     leading: SvgPicture.asset(
//       AssetsConstants.notifictionIcon,
//       width: 22,
//       color: theme.iconTheme.color,
//     ),
//     title: Text(
//       TranslationConstants.notifiction.t(context),
//       style: TextStyle(fontSize: 15),
//     ),
//     trailing: const Icon(Icons.arrow_forward_ios)),
// ListTile(
//     leading: SvgPicture.asset(
//       AssetsConstants.language,
//       width: 22,
//       color: theme.iconTheme.color,
//     ),
//     title: Text(
//       TranslationConstants.language.t(context),
//       style: TextStyle(fontSize: 15),
//     ),
//     onTap: () {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Language_Change(),
      //     ));
//     },
    // subtitle: lang.locale == 'en'
    //     ? Text('(English)')
    //     : Text('(العربية)'),
//     trailing: const Icon(Icons.arrow_forward_ios)),
