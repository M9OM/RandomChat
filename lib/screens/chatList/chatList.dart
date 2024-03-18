import 'package:chatme/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../provider/providerauth.dart';
import '/screens/chat_screen/chat_screen.dart';
import '/services/firebaseService.dart';

class ChatList extends StatelessWidget {
  ChatList();

  late Stream<QuerySnapshot> getList;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<ModelsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your List'),
        actions: [
          IconButton(
            onPressed: () {
              AuthService().signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getListUsersChat(postProvider.usersId, postProvider.usersId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Error: ${snapshot.error}');
          }

          var chatUsers = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatUsers.length,
            itemBuilder: (context, index) {
              var document = chatUsers[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        roomId: document.id.toString(),
                        ontherId: postProvider.usersId ==
                                document['userId'][0].toString()
                            ? document['userId'][1].toString()
                            : document['userId'][0].toString(),
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 85, 85, 85),
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(postProvider.usersId ==
                                  document['userId'][0].toString()
                              ? document['userId'][1].toString()
                              : document['userId'][0].toString())
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                              'Loading...'); // Placeholder text while data is being fetched
                        }
                        if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Display error message if there's an error
                        }
                        var userData = snapshot.data!.data() as Map<String,
                            dynamic>?; // Explicit cast to Map<String, dynamic>?
                        var displayName = userData?['displayName'] ?? 'Unknown';
// Extract displayName from document data
                        return Text(
                            displayName.toString()); // Display the displayName
                      },
                    ),

// var profileUrl = userData?['profileURL'] ?? 'Unknown';

                    leading: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(postProvider.usersId ==
                                    document['userId'][0].toString()
                                ? document['userId'][1].toString()
                                : document['userId'][0].toString())
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(''),
                            ); // Placeholder text while data is being fetched
                          }
                          if (snapshot.hasError) {
                            return Text(
                                'Error: ${snapshot.error}'); // Display error message if there's an error
                          }
                          var userData = snapshot.data!.data() as Map<String,
                              dynamic>?; // Explicit cast to Map<String, dynamic>?
                          var profileURL = userData?['photoURL'] ?? 'Unknown';

                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(profileURL),
                          );
                        }),
                    subtitle: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('rooms/${document.id}/messages')
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, messageSnapshot) {
                        if (messageSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                              '...'); // Show loading indicator while data is being fetched
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
                        return SizedBox(); // Return an empty space if there are no messages
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
