import 'dart:async';

import 'package:chatme/services/firebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppbarMsg extends StatefulWidget {
  final String name;
  final String pohtoURL;
  final bool online;
  final List? membres;
  final String ontherID;
final bool group;
  const AppbarMsg({
    Key? key,
    required this.name,
    required this.online,
    required this.pohtoURL,
    this.membres, required this.group, required this.ontherID,
  }) : super(key: key);

  @override
  State<AppbarMsg> createState() => _AppbarMsgState();
}

class _AppbarMsgState extends State<AppbarMsg> {
  late Stream<DocumentSnapshot> onlineUserStream;

  @override
  void initState() {
    onlineUserStream = FirebaseFirestore.instance.collection('users').doc(widget.ontherID).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: theme.appBarTheme.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new_sharp),
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
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage:
                                        NetworkImage(users[index]['photoURL']),
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
                    Text(
                      widget.name,
                      style: const TextStyle(fontSize: 17),
                    ),
                    widget.membres!.isEmpty
                        ? StreamBuilder<DocumentSnapshot>(
                            stream: onlineUserStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // While waiting for data to load, return a loading indicator or placeholder
                                return SizedBox(); // Example of using a CircularProgressIndicator
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
                                bool isOnline = DateTime.now().difference(
                                        lastOnlineDateTime) <
                                    Duration(minutes: 2);

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
                                      isOnline ? 'Online' : 'Offline',
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
          ],
        ),
      ),
    );
  }
}