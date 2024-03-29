import 'package:chatme/constant/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../AboutUs/aboutUs_screen.dart';

class AdvancedDrawerShow extends StatelessWidget {
  AdvancedDrawerShow(
      {super.key,
      required this.logoutTap,
      required this.darkModeTap,
      required this.isDark});
  final Function logoutTap;
  final Function darkModeTap;
  bool isDark;
  @override
  Widget build(BuildContext context) {
    var colorIcon = Theme.of(context).iconTheme.color;
    Color _colorWidth =Theme.of(context).cardColor;
double _width = 1.5;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 70,
          ),
          ListTile(
            shape: Border(
                bottom:
                    BorderSide(width: _width, color: _colorWidth)),
            leading: SvgPicture.asset(
              AssetsConstants.user,
              width: 30,
              color: colorIcon,
            ),
            title: Text(
              'Profile',
              style: TextStyle(fontFamily: 'Orbitron'),
            ),
          ),
          ListTile(
            shape: Border(
                bottom:
                    BorderSide(width: _width, color: _colorWidth)),
            onTap: () => darkModeTap(),
            leading: SvgPicture.asset(
              isDark ? AssetsConstants.light : AssetsConstants.dark,
              width: 30,
              color: colorIcon,
            ),
            title: Text(
              isDark ? 'Light' : "Dark",
              style: TextStyle(fontFamily: 'Orbitron'),
            ),
          ),
          ListTile(
            shape: Border(
                bottom:
                    BorderSide(width: _width, color: _colorWidth)),
            leading: SvgPicture.asset(
              AssetsConstants.settings,
              width: 30,
              color: colorIcon,
            ),
            title: Text(
              'Settings',
              style: TextStyle(fontFamily: 'Orbitron'),
            ),
          ),
          ListTile(
            shape: Border(
                bottom:
                    BorderSide(width: _width, color: _colorWidth)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUs(),
                ),
              );
            },
            leading: SvgPicture.asset(
              AssetsConstants.aboutAs,
              width: 30,
              color: colorIcon,
            ),
            title: Text(
              'About us',
              style: TextStyle(fontFamily: 'Orbitron'),
            ),
          ),
          ListTile(
            shape: Border(
                bottom:
                    BorderSide(width: _width, color: _colorWidth)),
            onTap: () => logoutTap(),
            leading: SvgPicture.asset(
              AssetsConstants.logout,
              width: 30,
              color: colorIcon,
            ),
            title: Text(
              'Logout',
              style: TextStyle(fontFamily: 'Orbitron'),
            ),
          ),
        ],
      ),
    );
  }
}
