import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/chat_screen/chat_screen.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Send a message
Future<void> sendMessage(String roomId, String text, String userId) async {
  await _firestore.collection('rooms/$roomId/messages').add({
    'text': text,
    'userId': userId,
    'timestamp': FieldValue.serverTimestamp(),
    'image': '',
    'likes': [],
  });
  lastMessage(roomId);
}

Future<void> lastMessage(String roomId) async {
  await _firestore.collection('rooms').doc(roomId).update({
    'timestamp': FieldValue.serverTimestamp(),
  });
}

Future<void> tringTimes(int trying, String userId) async {
  DocumentSnapshot snapshot =
      await _firestore.collection('trying').doc(userId).get();

  if (snapshot.exists) {
    _firestore.collection('trying').doc(userId).update({'trying': trying});
  } else {
    _firestore
        .collection('trying')
        .doc(userId)
        .set({'trying': 0, 'userId': userId});
  }
}

Stream<DocumentSnapshot> getTrying(String userId) {
  return _firestore.collection('trying').doc(userId).snapshots();
}

Future<void> createRoom(String roomId, String adminId, String ontherId) async {

  await _firestore.collection('rooms').doc(roomId).set({
    'timestamp': FieldValue.serverTimestamp(),
    'userId': [adminId, ontherId],
  });
}
Future<void> createGroup(String adminId,String roomId, List users, String nameGroup,BuildContext context) async {
users.add(adminId);
  await _firestore.collection('rooms').doc(roomId).set({
    'timestamp': FieldValue.serverTimestamp(),
    'userId': users,
    'NameOfGroup':nameGroup
  });

       // ignore: use_build_context_synchronously
      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            roomId: roomId,
                            ontherId: 'iojiouoiuoiuoi',
                            name: nameGroup,
                            membres:users,
                            pohtoURL: '',
                            online: false, group: true,
                          ),
                        ),
                      ).then((_) {
              // Remove the previous screen
              Navigator.pop(context);
            });


}

// Get chat messages
Stream<QuerySnapshot> getMessages(String roomId) {
  return _firestore
      .collection('rooms/$roomId/messages')
      .orderBy('timestamp')
      .snapshots();
}

Stream<QuerySnapshot> getListUsersChat(String uid, String uid2) {
  return _firestore
      .collection('rooms')
      .orderBy('timestamp', descending: true)
      .where('userId', arrayContainsAny: [uid]).snapshots();
}
void getListUsersChatt(String uid, String uid2) {
   _firestore
      .collection('rooms')
      .orderBy('timestamp', descending: true)
      .where('userId', arrayContainsAny: [uid]).snapshots();
}
Stream<QuerySnapshot> getListUsers() {
  return _firestore
      .collection('users')
      .orderBy('createdAt', descending: true)
      .snapshots();
}

Stream<QuerySnapshot> getListUserswhere(List uid) {
  return _firestore
      .collection('users')
      .orderBy('lastOnline', descending: true)
      .where('uid', whereIn: uid)
      .snapshots();
}



Stream<QuerySnapshot> getUsersEql(String uid) {
  return _firestore
      .collection('users').where('uid',isEqualTo: uid).snapshots();
}



Future<DocumentSnapshot<Map<String, dynamic>>> getListUserswheree(String uid) {
  return _firestore.collection('users').doc(uid).get();
}

Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
  return _firestore.collection('users').doc(uid).get();
}

Future<void> lastOnline(String userId) async {
  await _firestore.collection('users').doc(userId).update({
    'lastOnline': DateTime.now(),
  });
}

  // Future<DocumentSnapshot<Map<String, dynamic>>>getListUserswheree(String uid) {
  //   return _firestore.collection('users').doc(uid).get();
  // }


  Future sendEmail() async {
    final Email email = Email(
  body: 'Email body',
  subject: 'Email subject',
  recipients: ['sautma223@gmail.com'],
  cc: ['cc@example.com'],
  bcc: ['bcc@example.com'],
  isHTML: false,
);
 try {
      await FlutterEmailSender.send(email);
      print('success') ;
    } catch (error) {
      print(error);
            print(error.toString()) ;

    }}
  // Specify the recipient email address
