import 'package:chatme/constant/assets_constants.dart';
import 'package:chatme/services/auth.dart';
import 'package:chatme/ui/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../provider/providerauth.dart';
import '../../widgets/upgrade_dilog.dart';
import '/screens/chat_screen/chat_screen.dart';
import '/services/firebaseService.dart';

class ChatList extends StatelessWidget {
  const ChatList();

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<ModelsProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 55,),
          Upgrade_Dilog(),
          Expanded(
            child: FutureBuilder<Map<String, Map<String, dynamic>>>(
              future: preloadUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
              
                Map<String, Map<String, dynamic>> userDataMap = snapshot.data!;
              
                return Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        getListUsersChat(postProvider.usersId, postProvider.usersId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
              
                      var chatUsers = snapshot.data!.docs;
              
                      if (chatUsers.isEmpty) {
                        return const Center(
                          child: Text('No chat users'),
                        );
                      }
              
                      return ListView.builder(
                        itemCount: chatUsers.length,
                        itemBuilder: (context, index) {
                          var document = chatUsers[index];
                          var userIds = document['userId'] as List<dynamic>;
                          var documentData = document.data() as Map<String, dynamic>;
              
                          var nameOfGroup = documentData.containsKey('NameOfGroup')
                              ? documentData['NameOfGroup']
                              : '';
                          var otherUserId = userIds.firstWhere(
                              (id) => id != postProvider.usersId,
                              orElse: () => '');
              
                          if (otherUserId.isEmpty) {
                            return const SizedBox(); // Skip rendering if otherUserId is empty
                          }
              
                          // Get user data from preloaded map
                          var userData = userDataMap[otherUserId];
              
                          if (userData == null) {
                            return const SizedBox(); // Skip rendering if userData is null
                          }
                          if (nameOfGroup != '') {
                            return GestureDetector(
                            onTap: () {
              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    roomId: document.id.toString(),
                                    ontherId: otherUserId,
                                    membres:userIds,
                                    group:true,
                                    name: chatUsers[index]['NameOfGroup'],
                                    pohtoURL: '',
                                    online: true,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: theme.dividerColor,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                // trailing: Container(
                                //   padding: const EdgeInsets.all(8),
                                //   decoration: BoxDecoration(
                                //     color: theme.primaryColor,
                                //     shape: BoxShape.circle,
                                //   ),
                                //   child:  Text(
                                //     'G',
                                //     style: TextStyle(fontSize: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                //   ),
                                // ),
                                title: Text(
                                  chatUsers[index]['NameOfGroup'] ?? 'Unknown',
                                ),
                                leading:  Padding(
                                  padding: const EdgeInsets.only(bottom: 10,top: 10),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration( borderRadius: BorderRadius.circular(100),                              color: theme.cardColor,
              ),
                                    child: Image.asset('assets/images/bottomIcon/users-alt.png',color: theme.primaryColor,)),
                                ),
                                // subtitle: StreamBuilder<QuerySnapshot>(
                                //   stream: FirebaseFirestore.instance
                                //       .collection('rooms/${document.id}/messages')
                                //       .orderBy('timestamp', descending: true)
                                //       .limit(1)
                                //       .snapshots(),
                                //   builder: (context, messageSnapshot) {
                                //     if (messageSnapshot.connectionState ==
                                //         ConnectionState.waiting) {
                                //       return const Text('...');
                                //     }
                                //     if (messageSnapshot.hasError) {
                                //       return Text('Error: ${messageSnapshot.error}');
                                //     }
                                //     var messages = messageSnapshot.data!.docs;
                                //     if (messages.isNotEmpty) {
                                //       var lastMessage = messages.last;
                                //       return Text(lastMessage['text']);
                                //     }
                                //     return const SizedBox();
                                //   },
                                // ),
                              ),
                            ),
                          );
                          }
              
                          return GestureDetector(
                            onTap: () {
                              Timestamp lastOnlineTimestamp = userData['lastOnline'];
                              DateTime lastOnlineDateTime =
                                  lastOnlineTimestamp.toDate();
              
                              bool isOnline =
                                  DateTime.now().difference(lastOnlineDateTime) <
                                      const Duration(minutes: 5);
              
                              print(
                                  '$isOnline ${DateTime.now().difference(lastOnlineDateTime)}');
              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    roomId: document.id.toString(),
                                    ontherId: otherUserId,
                                    name: userData['displayName'],
                                    pohtoURL: userData['photoURL'],
                                    online: isOnline, group: false,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: theme.dividerColor,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                // trailing: Container(
                                //   padding: const EdgeInsets.all(8),
                                //   decoration: BoxDecoration(
                                //     color: theme.primaryColor,
                                //     shape: BoxShape.circle,
                                //   ),
                                //   child:  Text(
                                //     '1',
                                //     style: TextStyle(fontSize: 10, color: Theme.of(context).scaffoldBackgroundColor),
                                //   ),
                                // ),
                                title: Text(
                                  userData['displayName'] ?? 'Unknown',
                                ),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(userData['photoURL'] ?? ''),
                                ),
                                // subtitle: StreamBuilder<QuerySnapshot>(
                                //   stream: FirebaseFirestore.instance
                                //       .collection('rooms/${document.id}/messages')
                                //       .orderBy('timestamp', descending: true)
                                //       .limit(1)
                                //       .snapshots(),
                                //   builder: (context, messageSnapshot) {
                                //     if (messageSnapshot.connectionState ==
                                //         ConnectionState.waiting) {
                                //       return const Text('...');
                                //     }
                                //     if (messageSnapshot.hasError) {
                                //       return Text('Error: ${messageSnapshot.error}');
                                //     }
                                //     var messages = messageSnapshot.data!.docs;
                                //     if (messages.isNotEmpty) {
                                //       var lastMessage = messages.last;
                                //       return Text(lastMessage['text']);
                                //     }
                                //     return const SizedBox();
                                //   },
                                // ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, Map<String, dynamic>>> preloadUserData() async {
    Map<String, Map<String, dynamic>> userDataMap = {};
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    querySnapshot.docs.forEach((doc) {
      userDataMap[doc.id] = doc.data() as Map<String, dynamic>;
    });
    return userDataMap;
  }
}
