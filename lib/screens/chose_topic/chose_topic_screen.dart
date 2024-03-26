import 'package:chatme/screens/ChangeScreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../animation/side_animatin_route.dart';

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
    'Music 🎵',
    'Art 🎨',
    'Photography 📷',
    'Fashion 👗',
    'Gaming 🎮',
    'Movies 🎥',
    'Nature 🌿',
    'Science 🔬',
    'Health 🏥',
    'Fitness 💪',
    'Reading 📚',
    'Writing ✍️',
    'Technology 📱',
    'History 📜',
    'DIY 🛠️',
    'Meditation 🧘',
    'Pets 🐶',
    'Food 🍕',
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
      itemCount: topicsWithEmojis.length, // Number of items in the grid
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              selected.add(topicsWithEmojis[index]);
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
  onTap:() {
       Navigator.pushReplacement(
                              context,
                              SlideAnimationRoute(
                                screen: const ChangeScreen(),
                              ),
                            );
  },
  child:   Padding(
    padding: const EdgeInsets.all(8.0),
    child:   Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.all(10),
    child: Text('Get Started', style: TextStyle(fontSize: 20),),
    ),
  ),
),

SizedBox(height: 50,),
        ],
      ),
    );
  }
}
