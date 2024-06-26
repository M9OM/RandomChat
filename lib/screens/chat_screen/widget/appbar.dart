import 'dart:async';

import 'package:chatme/constant/assets_constants.dart';
import 'package:chatme/constant/str_extntion.dart';
import 'package:chatme/services/firebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constant/translate_constat.dart';
import '../../../provider/providerauth.dart';
import '../../../widgets/dilog.dart';

class AppbarMsg extends StatefulWidget {
  final String name;
  final String pohtoURL;
  final bool online;
  final List? membres;
  final String ontherID;
  final bool group;
  final String roomID;
  const AppbarMsg({
    Key? key,
    required this.name,
    required this.online,
    required this.pohtoURL,
    this.membres,
    required this.group,
    required this.ontherID,
    required this.roomID,
  }) : super(key: key);

  @override
  State<AppbarMsg> createState() => _AppbarMsgState();
}

class _AppbarMsgState extends State<AppbarMsg> {
  late Stream<DocumentSnapshot> onlineUserStream;

  @override
  void initState() {
    onlineUserStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.ontherID)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAdmin = Provider.of<ModelsProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 20),
                    widget.membres!.isEmpty
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(widget.pohtoURL),
                          )
                        : SizedBox(
                            height: 50,
                            width: 140,
                            child: StreamBuilder(
                              stream: getListUserswhere(widget.membres!),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return const Placeholder(); // Placeholder widget or loading indicator
                                }
                                var users = snapshot.data!.docs;
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundImage: NetworkImage(
                                            users[index]['photoURL']),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(fontSize: 17),
                            ),
                            SizedBox(width: 5,),
                            // SvgPicture.asset(AssetsConstants.va,color: Colors.blue,width: 14,)
                          ],
                        ),
                        widget.membres!.isEmpty
                            ? StreamBuilder<DocumentSnapshot>(
                                stream: onlineUserStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // While waiting for data to load, return a loading indicator or placeholder
                                    return const SizedBox(); // Example of using a CircularProgressIndicator
                                  } else if (snapshot.hasError) {
                                    // If an error occurs, return an error message or widget
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Once data is loaded successfully, proceed with building the UI
                                    var onlineUser = snapshot.data!;
                                    Timestamp lastOnlineTimestamp =
                                        onlineUser['lastOnline'];
                                    DateTime lastOnlineDateTime =
                                        lastOnlineTimestamp.toDate();
                                    bool isOnline = DateTime.now()
                                            .difference(lastOnlineDateTime) <
                                        const Duration(minutes: 2);

                                    return Row(
                                      children: [
                                        Icon(
                                          isOnline
                                              ? Icons.circle
                                              : Icons.circle,
                                          color: isOnline
                                              ? Colors.green
                                              : Colors.red,
                                          size: 10,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          isOnline ? TranslationConstants.online.t(context) :    TranslationConstants.offline.t(context),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              )
                            : const SizedBox()
                      ],
                    ),
                  ],
                ),
                InkWell(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {

                          return AlertDialog(
                            
                            actions: <Widget>[
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(onTap: () {}, child:  Text(TranslationConstants.hobbies.t(context))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(onTap: () {}, child:  Text(TranslationConstants.theme.t(context))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  widget.membres!.isEmpty
                                      ? InkWell(
                                          onTap: () {
                                            dialogBuilder(
                                              context,
                                              text:
                                                  '${TranslationConstants.you_want_block_msg.t(context)} ${widget.name}?',
                                              onTap: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('rooms')
                                                    .doc(widget.roomID)
                                                    .delete();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          child:  Text(TranslationConstants.block.t(context)))
                                      : InkWell(
                                          onTap: () {
                                            dialogBuilder(
                                              context,
                                              text:
                                                  '${TranslationConstants.you_want_exit_group_msg.t(context)} ${widget.name}?',
                                              onTap: () async {
                                                await FirebaseFirestore.instance
  .collection('rooms')
  .doc(widget.roomID)
  .update({
    'userId': FieldValue.arrayRemove([userAdmin.usersId]),
  });

                                                    
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          child:  Text(TranslationConstants.exitGroup.t(context)))
                                ],
                              ),
                            )
                          ]);
                        },
                      );
                    },
                    child: const Icon(Icons.menu))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
