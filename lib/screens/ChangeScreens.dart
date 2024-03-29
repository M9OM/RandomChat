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
    Color? selectedItemColor = Theme.of(context).selectedRowColor;
    Color? unSelectedItemColor = Theme.of(context).disabledColor;

    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 1, color: Theme.of(context).cardColor))),
      // borderRadius: BorderRadius.circular(30),
      child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    ? Image.asset(
                        AssetsConstants.homeIcon,
                        color: selectedItemColor,
                        width: 25,
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
                    ? Image.asset(
                        AssetsConstants.searchIcon,
                        color: selectedItemColor,
                        width: 25,
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
                    Image.asset(AssetsConstants.chatIcon,
                        width: 25, color: selectedItemColor)
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
