import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../ui/color.dart';
import '/screens/chat_screen/widget/dilog.dart';
import '../../services/firebaseService.dart';
import 'widget/buble/buble.dart';
import 'widget/buble/color/color.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String ontherId;

  const ChatScreen({Key? key, required this.roomId, required this.ontherId})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  final TextEditingController _textController = TextEditingController();
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final player = AudioPlayer();
  String themeChat = '1';
  late User user;

  File? pickedFileto;
  Future<File?> pickImage() async {
    var picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        pickedFileto = File(pickedFile.path);
      });

      return File(pickedFile.path);
    }
    return null;
  }

  late Future<DocumentSnapshot> userDataFuture;
  late Stream<QuerySnapshot> chatSnapshotStream;
  String profileURLOtherUser = '';
  Future<void> _fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.ontherId)
          .get();

      setState(() {
        profileURLOtherUser = documentSnapshot['photoURL'];
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    userDataFuture = getUserData(widget.ontherId);

    chatSnapshotStream = getMessages(widget.roomId);

    _listKey.currentState
        ?.insertItem(0, duration: const Duration(milliseconds: 300));

    getTheme();
    _fetchData();
    _listScrollController = ScrollController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void playSound() async {
    await player.play(AssetSource('image/newmsg.mp3'));
  }

  void getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      themeChat = prefs.getString('theme') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/bakcround$themeChat.gif',
                ),
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    Color.fromARGB(169, 0, 0, 0), BlendMode.darken))),
        child: GestureDetector(
          onLongPress: () {
            blackTheme() {
              setState(() {
                themeChat = '1';
              });
            }

            blueTheme() {
              setState(() {
                themeChat = '2';
              });
            }

            redTheme() {
              setState(() {
                themeChat = '3';
              });
            }

            Dilog().dialogBuilder(context, blackTheme, blueTheme, redTheme);
          },
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: const Icon(
                                      Icons.arrow_back_ios_new_sharp),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[900],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text('...'),
                              ],
                            ),
                          ],
                        ),
                      ); // Show a loading indicator while waiting for data
                    }
                    if (!snapshot.hasData) {
                      return const Text(
                          'No data available'); // Handle the case when there is no data
                    }
                    final userData = snapshot.data;
                    if (userData != null) {
                      final photoURL = userData['photoURL'].toString();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                      Icons.arrow_back_ios_new_sharp),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(photoURL),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(userData['displayName']),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text(
                          'User data is null'); // Handle the case when user data is null
                    }
                  },
                ),
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: chatSnapshotStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No messages'));
                  }

                  var messages = snapshot.data!.docs;


                  // Detect if new messages have arrived
                  if (_listKey.currentState != null &&
                      _listKey.currentState!.widget.initialItemCount !=
                          messages.length) {
                    final newIndex = messages.length -
                        _listKey.currentState!.widget.initialItemCount;
                    _listKey.currentState!.insertItem(newIndex);
                  }

                  return AnimatedList(
                    reverse: true,
                    key: _listKey,
                    controller: _listScrollController,
                    initialItemCount: messages.length,
                    itemBuilder: (context, index, animation) {
                      final reversedIndex = messages.length - 1 - index;
                      return SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.vertical,
                        child: Buble(
                          text: messages[reversedIndex]['text'],
                          isMe: user.uid == messages[reversedIndex]['userId'],
                          profileUrlOther: profileURLOtherUser,
                        ),
                      );
                    },
                  );
                },
              )),
              //piked image
              if (pickedFileto != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: 200, minHeight: 100),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(pickedFileto!)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              pickedFileto = null;
                            });
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            size: 30,
                            color: Colors.white,
                            shadows: [Shadow(offset: Offset(2, 2))],
                          )),
                    )
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        maxLines: 4,
                        minLines: 1,
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'Orbitron'),
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: mainColor,
                              )),
                          hintStyle: const TextStyle(
                              color: Colors.white, fontFamily: 'Orbitron'),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.indigoAccent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            pickImage();
                          },
                          child: Image.asset(
                            'assets/images/images.png',
                            width: 30,
                            color: iconColor,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              playSound();

                              lastMessage(widget.roomId);
                              if (_textController.text.isNotEmpty) {
                                sendMessage(widget.roomId, _textController.text,
                                    user.uid);

                                _textController.clear();
                                scrollListToEND();
                              }
                            },
                            child: Image.asset(
                              'assets/images/send.png',
                              width: 30,
                              color: iconColor,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _insertItem(int index) {
    _listKey.currentState!.insertItem(index);
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeOut,
    );
  }
}
