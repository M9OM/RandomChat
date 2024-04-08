import 'package:chatme/constant/str_extntion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constant/assets_constants.dart';
import '../../../constant/translate_constat.dart';
import '../../../provider/DarktModeProvider.dart';

class Details_SettingCard extends StatelessWidget {
  Details_SettingCard(
      {super.key,
      required this.iSswitch,
      required this.onTap,
       this.subtitle,
      required this.title, required this.iconSvg});
  bool iSswitch;
  Function onTap;
  String title;
  String? subtitle;
String iconSvg;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final lang = Provider.of<DataProvider>(context);
    final darktMode = Provider.of<DataProvider>(context);

    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: theme.dividerColor))),
      child: ListTile(
          onTap: () {
            !iSswitch ? onTap() : null;
          },
          leading: SvgPicture.asset(
            iconSvg,
            width: 22,
            color: theme.iconTheme.color,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 15),
          ),
          subtitle:subtitle !=null? Text(subtitle!):null,
          trailing: iSswitch
              ? Switch(
                  value: darktMode.isDarkMode,
                  activeColor: theme.primaryColor,
                  onChanged: (value) {
                    onTap();
                  },
                )
              : const Icon(Icons.arrow_forward_ios)),
    );
  }
}
