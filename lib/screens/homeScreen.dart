// ignore: file_names
import 'package:chatme/screens/chatList/chatList.dart';
import 'package:chatme/screens/findToChat/findToChat.dart';
import 'package:flutter/material.dart';
import '../constant/assets_constants.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _sreens_of_botoomBarState();
}

class _sreens_of_botoomBarState extends State<homeScreen> {
  int currentIndex = 0;
  final screens = [
    const FindToChat(),
    ChatList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      // drawer: AppDrawer(),

      bottomNavigationBar: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: bottomNavigationBarWidget(
                currentIndex: currentIndex,
                indextChange: (index) {
                  setState(() => currentIndex = index);
                }),
          ),
        ),
      ),
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
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: BottomNavigationBar(
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
                    ? // selected item
                    Image.asset(
                        AssetsConstants.chatIcon,
                        color: selectedItemColor,
                        width: 25,
                      )
                    : // unselected item
                    Image.asset(
                        AssetsConstants.chatIcon,
                        color: unSelectedItemColor,
                        width: 25,
                      ),
                label: ''),          ]),
    );
  }
}

