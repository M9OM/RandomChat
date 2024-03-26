import 'dart:async';
import 'dart:math';
import 'package:chatme/screens/chatList/chatList.dart';
import 'package:chatme/screens/chat_screen/chat_screen.dart';
import 'package:chatme/screens/findToChat/loading.dart';
import 'package:chatme/ui/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../services/firebaseService.dart';
import '../payment/payment.dart';

class FindToChat extends StatefulWidget {
  const FindToChat({Key? key}) : super(key: key);

  @override
  State<FindToChat> createState() => _FindToChatState();
}

int nameIndex = 0;
int imageIndex = 0;

List image = [
  'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?size=626&ext=jpg',
  'https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671142.jpg?size=626&ext=jpg',
  'https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671157.jpg?w=900&t=st=1710068057~exp=1710068657~hmac=bc8e6cd95ff6878734620e062bda14761474539b17d0f1b5b94c244cff1ec7ee',
  'https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671134.jpg?w=900&t=st=1710068071~exp=1710068671~hmac=61ddfb38f407af33e0a40a60fb2e2012e01d7c3870b4322c0ebd0fada0734f8d',
  'https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671136.jpg?t=st=1710068071~exp=1710068671~hmac=d571b686445167b4cd3749c463ab993ee10f1af8df95127eb0def87e6b87ecfa'
];
List name = ['mohammed', 'salem', 'shahad', 'fatima', 'abood', 'maram'];
bool searching = false;

class _FindToChatState extends State<FindToChat> {
  User? user; // Declare user without initialization
  late Future<DocumentSnapshot> userDataFuture;
  late Stream<QuerySnapshot> _userStream;
  late Timer _timer; // Define the timer variable

  String roomId = '';
  String senderId = '';
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Initialize user in initState
    userDataFuture = getUserData(user!.uid);
    _userStream = getListUsers();

    int i = 0;
    Timer.periodic(const Duration(microseconds: 300000), (timer) {
      setState(() {
        imageIndex++;
        nameIndex++;

        if (imageIndex == image.length) {
          imageIndex = 0;
        }
        if (nameIndex == name.length) {
          nameIndex = 0;
        }
      });
    });
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModalProgressHUD(
      inAsyncCall: searching,
      progressIndicator: const LoadingUsers(),
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No users available');
            }

            var users = snapshot.data!.docs;
            // ignore: list_remove_unrelated_type

            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: getTrying(user!.uid),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('No users available');
                      }

                      var tringTime = 0;
                      if (!snapshot.data!.exists) {
                        tringTime = 0;
                      } else {
                        tringTime = snapshot.data!['trying'];
                      }

                      return InkWell(
                        onTap: () async {

                          bool loop =true;
                          while (loop) {
                            if (tringTime < 11) {
                              tringTimes(tringTime + 1, user!.uid);

                              searching = true;
                              Random random = Random();
                              int randomNumber = random.nextInt(users.length);

                              print(
                                  'roomId before Future.delayed: $roomId'); // Check if null before delay
                              await Future.delayed(
                                  const Duration(milliseconds: 7000), () async {
                                setState(() {
                                  roomId =
                                      '${DateTime.now().microsecondsSinceEpoch}${DateTime.now().millisecond}';
                                });
                                print('roomId after assignment: $roomId');
                                print(users[randomNumber]['uid']);
                                if (users[randomNumber]['uid'] == user!.uid) {
                                  loop=true;
                                }else{
                                  loop =false;

                                createRoom(roomId, user?.uid ?? '',
                                    users[randomNumber]['uid']);
                                setState(() {
                                  senderId = users[randomNumber]['uid'];
                                });
                                Timestamp lastOnlineTimestamp =
                                    users[randomNumber]['lastOnline'];
                                DateTime lastOnlineDateTime =
                                    lastOnlineTimestamp.toDate();

                                bool isOnline = DateTime.now()
                                        .difference(lastOnlineDateTime) <
                                    Duration(minutes: 5);

                                print(
                                    '$isOnline ${DateTime.now().difference(lastOnlineDateTime)}');

                                if (roomId != null) {
                                  
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            group: false,
                                                roomId: roomId,
                                                ontherId: users[randomNumber]
                                                    ['uid'],
                                                name: users[randomNumber]
                                                    ['displayName'],
                                                pohtoURL: users[randomNumber]
                                                    ['photoURL'],
                                                online: isOnline,
                                              )));
                                }
                                searching = false;



                            }
                            
                            
                            });
                            } else {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentScreen()));
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text('Start Chatting!'),
                              Text('${tringTime}/5'),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ));
          },
        ),
      ),
    );
  }
}
