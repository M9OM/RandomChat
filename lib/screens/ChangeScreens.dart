// ignore: file_names
// ignore_for_file: deprecated_member_use

import 'package:chatme/screens/chatList/chatList.dart';
import 'package:chatme/screens/findToChat/findToChat.dart';
import 'package:flutter/material.dart';
import '../constant/assets_constants.dart';
import '../ui/color.dart';
import 'home/homeScreen.dart';

class ChangeScreen extends StatefulWidget {
  const ChangeScreen({super.key});

  @override
  State<ChangeScreen> createState() => _sreens_of_botoomBarState();
}


class _sreens_of_botoomBarState extends State<ChangeScreen> {
  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    const FindToChat(),
    ChatList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      // drawer: AppDrawer(),

      bottomNavigationBar: bottomNavigationBarWidget(
          currentIndex: currentIndex,
          indextChange: (index) {
            setState(() => currentIndex = index);
          }),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
    );
  }
}

class bottomNavigationBarWidget extends StatelessWidget {
  const bottomNavigationBarWidget(
      {super.key, required this.currentIndex, required this.indextChange});
  final int currentIndex;
  final Function indextChange;

  @override
  Widget build(BuildContext context) {
    // Get the current index from the widget's properties

    // Define the colors for the selected and unselected icons
    Color selectedItemColor = Colors.white;
    Color unSelectedItemColor = Colors.grey;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: ThemeData().bottomAppBarTheme.color,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 2,
          currentIndex: currentIndex,
          onTap: (index) {
            indextChange(index);
          },
          items: [
            BottomNavigationBarItem(
                icon: currentIndex == 0
                    // selected item
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Image.asset(
                          AssetsConstants.homeIcon,
                          width: 25,
                        ),
                      )

                    // unselected item
                    : Image.asset(
                        AssetsConstants.homeIcon,
                        color: unSelectedItemColor,
                        width: 25,
                      ),
                label: ''),
                            BottomNavigationBarItem(
                icon: currentIndex == 1
                    // selected item
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Image.asset(
                          AssetsConstants.searchIcon,
                          width: 25,
                        ),
                      )

                    // unselected item
                    : Image.asset(
                        AssetsConstants.searchIcon,
                        color: unSelectedItemColor,
                        width: 25,
                      ),
                label: ''),
            BottomNavigationBarItem(
                icon: currentIndex == 2
                    ? // selected item
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Image.asset(
                          AssetsConstants.chatIcon,
                          width: 25,
                        ),
                      )
                    : // unselected item
                    Image.asset(
                        AssetsConstants.chatIcon,
                        color: unSelectedItemColor,
                        width: 25,
                      ),
                label: ''),
          ]),
    );
  }
}
