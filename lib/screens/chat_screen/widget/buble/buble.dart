import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

import '../../../../ui/color.dart';
import 'color/color.dart';

class Buble extends StatelessWidget {
  const Buble({
    Key? key,
    required this.isMe,
    required this.text,
    required this.profileUrlOther,
  }) : super(key: key);

  final bool isMe;
  final String text;
  final String profileUrlOther;

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      //ur buble
      child: Align(
        alignment: isMe ? meAlignment : aiAlignment,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: isMe
              ? Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    color: meColor,
                    borderRadius: borderRadiusMe,
                  ),
                  child: Column(
                    children: [


                      Text(text),
                    ],
                  ),
                )
              :

              // onther user buble
              Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: NetworkImage(profileUrlOther),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        padding: padding,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/image/8.gif'),
                              fit: BoxFit.cover),
                          color: mainColor,
                          borderRadius: borderRadiusOther,
                        ),
                        child: Text(text),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
