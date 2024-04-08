import 'package:chatme/screens/ChangeScreens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../animation/side_animatin_route.dart';
import '../../provider/providerauth.dart';

// ignore: camel_case_types
class ChoseTopic_screen extends StatefulWidget {
  const ChoseTopic_screen({super.key});

  @override
  State<ChoseTopic_screen> createState() => _ChoseTopic_screenState();
}

// ignore: camel_case_types
class _ChoseTopic_screenState extends State<ChoseTopic_screen> {
  List<String> topicsWithEmojis = [
    'Sports ⚽️',
    'Travel ✈️',
    'Programming 💻',
    'Cooking 🍳',
    'Art 🎨',
    'Photography 📷',
    'Gaming 🎮',
    'Movies 🎥',
    'Reading 📚',
    'History 📜',
    'Meditation 🧘',
    'Pets 🐶',
    'Education 🎓',
    'Business 💼',
    'Finance 💰',
    'Politics 🗳️',
    'Space 🚀',
    'Environment 🌱',
    'Cars 🚗',
    'Animals 🐾'
  ];

  List selected = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<ModelsProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Text(
              'Select Your Interest',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                  childAspectRatio: 3, // Aspect ratio (width / height)
                ),
                itemCount:
                    topicsWithEmojis.length, // Number of items in the grid
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {

                     setState(() {
   selected.contains(topicsWithEmojis[index])?selected.remove(topicsWithEmojis[index]): selected.add(topicsWithEmojis[index]);  
    //  final snackBar = SnackBar(
    // backgroundColor: theme.cardColor,
    //         content: Center(child:  Text('You cannot select more than 4 topics',style: TextStyle(color: theme.iconTheme.color),)),
    //         duration: const Duration(milliseconds: 1500),
    //         width: 280.0,
    //         padding:EdgeInsets.all(15),
    //         behavior: SnackBarBehavior.floating,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10.0),
    //         ));
    //       ScaffoldMessenger.of(context).showSnackBar(snackBar);


print('wdw');
});

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: !selected.contains(topicsWithEmojis[index])
                            ? const Border()
                            : Border.all(width: 2, color: theme.primaryColor),
                      ),
                      child: Center(
                        child: Text(
                          topicsWithEmojis[index],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.usersId)
                  .update({'interest': selected});

              Navigator.pushReplacement(
                context,
                SlideAnimationRoute(
                  screen: const ChangeScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(10),
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
