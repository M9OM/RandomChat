import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CardUsers extends StatelessWidget {
   CardUsers({super.key, required this.isOnline, required this.onTap, required this.displayName, required this.photoURL});
bool isOnline;
String displayName;
String photoURL;
Function onTap;
  @override
  Widget build(BuildContext context) {
            final theme = Theme.of(context);

    return InkWell(
      onTap: () => onTap(),
      highlightColor:Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.cardColor,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                      photoURL),
                                                  backgroundColor: theme
                                                      .scaffoldBackgroundColor,
                                                ),
                                                isOnline
                                                    ? Container(
                                                        width: 15,
                                                        height: 15,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 3,
                                                            color:
                                                                theme.cardColor,
                                                          ),
                                                          color: Colors.green,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 15,
                                                        height: 15,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 3,
                                                            color:
                                                                theme.cardColor,
                                                          ),
                                                          color: Colors.red,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(displayName),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
    );
  }
}