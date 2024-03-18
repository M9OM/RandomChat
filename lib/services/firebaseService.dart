import 'package:cloud_firestore/cloud_firestore.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a message
  Future<void> sendMessage(String roomId, String text, String userId) async {
    await _firestore.collection('rooms/$roomId/messages').add({
      'text': text,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'image': '',
      'likes':[],
    });
lastMessage(roomId);
  }
    Future<void> lastMessage(String roomId) async {
    await _firestore.collection('rooms').doc(roomId).update({
      'timestamp': FieldValue.serverTimestamp(),
    });
  }




  Future<void> tringTimes(int trying, String userId) async {
DocumentSnapshot snapshot = await _firestore.collection('trying').doc(userId).get();

 if(snapshot.exists){
     _firestore.collection('trying').doc(userId).update({'trying':trying});
    
    
    
    }else{
     _firestore.collection('trying').doc(userId).set({'trying':0,'userId':userId});

    }
  }

   Stream<DocumentSnapshot> getTrying(String userId) {

    return _firestore.collection('trying').doc(userId).snapshots();


  }
Future<void> createRoom(String roomId, String adminId, String ontherId) async {
  await _firestore.collection('rooms').doc(roomId).set({
    
    
    'timestamp': FieldValue.serverTimestamp(),
    'userId':[adminId,ontherId],
});
}

  // Get chat messages
  Stream<QuerySnapshot> getMessages(String roomId) {
    return _firestore.collection('rooms/$roomId/messages').orderBy('timestamp').snapshots();
  }

    Stream<QuerySnapshot> getListUsersChat(String uid,String uid2) {

    return _firestore.collection('rooms').orderBy('timestamp',descending: true).where('userId', arrayContainsAny:[uid,uid2] ).snapshots();


  }


  


    Stream<QuerySnapshot> getListUsers() {
    return _firestore.collection('users').orderBy('createdAt',descending: true).snapshots();
  }

    Stream<QuerySnapshot> getListUserswhere(String uid) {
    return _firestore.collection('users').orderBy('createdAt',descending: true).where('uid',isEqualTo: uid).snapshots();
  }
    Future<DocumentSnapshot<Map<String, dynamic>>>getListUserswheree(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) {
  return _firestore.collection('users').doc(uid).get();
}

  // Future<DocumentSnapshot<Map<String, dynamic>>>getListUserswheree(String uid) {
  //   return _firestore.collection('users').doc(uid).get();
  // }