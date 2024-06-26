import 'package:flutter/material.dart';
import '../../../../ui/color.dart';

class Buble extends StatelessWidget {
  const Buble({
    Key? key,
    required this.isMe,
    required this.text,
    required this.profileUrlOther,
    required this.name,
  }) : super(key: key);

  final bool isMe;
  final String text;
  final String profileUrlOther;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      //ur buble
      child: Container(
        alignment: isMe ? meAlignment : aiAlignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: isMe
                  ? Container(
                      padding: padding,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
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
                              color: theme.primaryColor,
                              borderRadius: borderRadiusOther,
                            ),
                            child: Text(
                              text,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
