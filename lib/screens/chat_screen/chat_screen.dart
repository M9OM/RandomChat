import 'dart:async';
import 'dart:io';

import 'package:chatme/constant/str_extntion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../constant/translate_constat.dart';
import '../../provider/providerauth.dart';
import '../../ui/color.dart';
import '/screens/chat_screen/widget/dilog.dart';
import '../../services/firebaseService.dart';
import 'widget/appbar.dart';
import 'widget/buble/buble.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String ontherId;
  final String name;
  final String pohtoURL;
  final bool online;
  final List? membres;
  final bool group;
  const ChatScreen(
      {Key? key,
      required this.roomId,
      required this.name,
      required this.online,
      required this.pohtoURL,
      required this.ontherId,
      this.membres, required this.group})
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
    late Future<Map<String, Map<String, dynamic>>> getUserDataa;

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
bool isTextNotEmpty =false;
  @override
  void initState() {
    super.initState();
  _textController.addListener(() {
  setState(() {
    // Check if the text is empty
    if (_textController.text.isNotEmpty) {
      isTextNotEmpty = true;
    } else {
      isTextNotEmpty = false;
    }
  });
});

    user = FirebaseAuth.instance.currentUser!;
getUserDataa = preloadUserData();
    lastOnline(user.uid);
    Timer.periodic(const Duration(minutes: 2), (timer) {
      lastOnline(user.uid);
    });

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
    final theme = Theme.of(context);
    final userAdmin = Provider.of<ModelsProvider>(context);

    return Scaffold(
      body: FutureBuilder<Map<String, Map<String, dynamic>>>(
      future: getUserDataa,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        Map<String, Map<String, dynamic>> userDataMap = snapshot.data!;
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/bakcround$themeChat.gif',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                        Color.fromARGB(169, 0, 0, 0), BlendMode.darken))),
            child: GestureDetector(

              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Column(
                children: <Widget>[
                  AppbarMsg(
                      pohtoURL: widget.pohtoURL,
                      online: widget.online,
                      name: widget.name,
                      group:widget.group,
                      roomID:widget.roomId,
                      ontherID:widget.ontherId,
                      membres: widget.membres ?? []                  
                      ),
      
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: chatSnapshotStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return  Center(child: Text(TranslationConstants.noMassge.t(context)));
                      }
      
                      var messages = snapshot.data!.docs;
      
                      // Detect if new messages have arrived
                      if (_listKey.currentState != null &&
                          _listKey.currentState!.widget.initialItemCount !=
                              messages.length) {
                        final newIndex = messages.length -
                            _listKey.currentState!.widget.initialItemCount;
                                    HapticFeedback.mediumImpact();

                        _listKey.currentState!.insertItem(newIndex-1);
                      }

                      return AnimatedList(
                        reverse: true,
                        key: _listKey,
                        controller: _listScrollController,
                        initialItemCount: messages.length,
                        itemBuilder: (context, index, animation) {
                          final reversedIndex = messages.length - 1 - index;
                           var userData = userDataMap[messages[reversedIndex]['userId']];

                          return SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.vertical,
                            child: Buble(
                              text: messages[reversedIndex]['text'],
                              isMe: user.uid == messages[reversedIndex]['userId'],
                              profileUrlOther: userData!['photoURL'],
                              name: userData['displayName'],
                              
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
                              const BoxConstraints(maxWidth: 200, minHeight: 100),
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
                              child: const Icon(
                                Icons.cancel_outlined,
                                size: 30,
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
                            style: const TextStyle(),
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: TranslationConstants.type_your_msg.t(context),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 93, 93, 93),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                  )),
                              hintStyle: const TextStyle(),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.indigoAccent,
                                  width: 2,
                                ),
                              ),
                              suffixIcon:isTextNotEmpty? InkWell(
                                  onTap: () {
                                    playSound();
      
                                    lastMessage(widget.roomId);
                                    if (_textController.text.isNotEmpty) {
                                      sendMessage(widget.roomId,
                                          _textController.text, userAdmin.usersId);
      
                                      _textController.clear();
                                      scrollListToEND();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                          color: theme.primaryColor,
                                          shape: BoxShape.circle),
                                      child: Image.asset(
                                        'assets/images/send.png',
                                        width: 25,
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                    ),
                                  )):SizedBox()
                            ),
                          ),
                        ),
                        // const SizedBox(width: 8.0),
                        Row(
                          children: [
                            // InkWell(
                            //   onTap: () {
                            //     pickImage();
                            //   },
                            //   child: Container(
                            //       padding: const EdgeInsets.all(9),
                            //       decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                            //     child: Image.asset(
                            //       'assets/images/images.png',
                            //       width: 25,
                            //       color: iconColor,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
