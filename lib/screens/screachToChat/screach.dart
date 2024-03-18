import 'package:chatme/provider/providerauth.dart';
import 'package:chatme/screens/chatList/chatList.dart';
import 'package:chatme/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '/screens/chat_screen/chat_screen.dart';
import '/services/firebaseService.dart';

class UserToChat extends StatefulWidget {
  const UserToChat({Key? key});

  @override
  State<UserToChat> createState() => _UserToChatState();
}

class _UserToChatState extends State<UserToChat> {
  User? user; // Declare user without initialization

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // Initialize user in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              AuthService().signOut();
            },
            icon: Icon(Icons.logout)),
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatList(),
            ),
          );
          // createRoom('${DateTime.now().microsecondsSinceEpoch}${DateTime.now().millisecond}');
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getListUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while data is being fetched
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          var chatUsers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatUsers.length,
            itemBuilder: (context, index) {
              var document = chatUsers[index];
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 85, 85, 85),
                    ),
                  ),
                ),
                child: 
                        
                     ListTile(
                      onTap: () {
                        createRoom(
                            '${DateTime.now().microsecondsSinceEpoch}${DateTime.now().millisecond}',
                            user!.uid,
                            chatUsers[index]['uid']);
                
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         ChatScreen(roomId: document.id.toString()),
                        //   ),
                        // );
                      },
                      title: Text(chatUsers[index]['displayName']),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage('${chatUsers[index]['photoURL']}'),
                      ),
                      subtitle: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('rooms/${document.id}/messages')
                            .orderBy('timestamp', descending: true)
                            .limit(1)
                            .snapshots(),
                        builder: (context, messageSnapshot) {
                          if (messageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                                'Loading...'); // Show loading indicator while data is being fetched
                          }
                          if (messageSnapshot.hasError) {
                            return Text('Error: ${messageSnapshot.error}');
                          }
                          var messages = messageSnapshot.data!.docs;
                          if (messages.isNotEmpty) {
                            var lastMessage = messages.last;
                            return Text(lastMessage[
                                'text']); // Display the last message in the list tile
                          }
                          return const SizedBox(); // Return an empty space if there are no messages
                        },
                      ),
                    )
                  
                
              );
            },
          );
        },
      ),
    );
  }
}
