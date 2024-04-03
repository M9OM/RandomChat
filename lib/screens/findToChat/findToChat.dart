import 'dart:async';
import 'dart:math';
import 'package:chatme/constant/str_extntion.dart';
import 'package:chatme/screens/chatList/chatList.dart';
import 'package:chatme/screens/chat_screen/chat_screen.dart';
import 'package:chatme/screens/findToChat/loading.dart';
import 'package:chatme/ui/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../constant/translate_constat.dart';
import '../../services/firebaseService.dart';
import '../payment/payment.dart';

class FindToChat extends StatefulWidget {
  const FindToChat({Key? key}) : super(key: key);

  @override
  State<FindToChat> createState() => _FindToChatState();
}



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

  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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

                        setState(() {
                                             searching = true;

                        });

                        bool loop =true;
                        while (loop) {
                          if (tringTime < 120) {
                            tringTimes(tringTime + 1, user!.uid);
                            Random random = Random();
                            int randomNumber = random.nextInt(users.length);
Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoadingUsers(
                                            )));
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
                                            )),).then((_) {
              // Remove the previous screen
              Navigator.pop(context);
            });;
                              }
setState(() {
                                searching = false;

});



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
                             Text(TranslationConstants.start_chating.t(context),),
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
    );
  }
}
