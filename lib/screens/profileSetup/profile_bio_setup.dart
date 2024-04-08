import 'dart:io';
import 'package:chatme/screens/chose_topic/chose_topic_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../animation/side_animatin_route.dart';

class profileAvatar extends StatefulWidget {
  const profileAvatar({super.key});

  @override
  State<profileAvatar> createState() => _profileAvatarState();
}

class _profileAvatarState extends State<profileAvatar> {
  File? _image;
  late User siguneduser;
  String username = '';
  String bio = '';
  bool loging = false;
  Future _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      _image = File(pickedImage!.path);
    });
  }

// Chack if the username is available
  // void _handleChanges(String username) async {
  //   setState(() {});
  //   isAvailable = await AuthService.isUsernameAvailable(username);
  //   setState(() async {
  //     username = username;
  //     if (isAvailable) {
  //     } else {
  //       Fluttertoast.showToast(
  //           msg:
  //               "Oops! The username you entered is already in use. Please choose a different username to continue",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.deepPurple,
  //           textColor: Colors.white,
  //           fontSize: 18.0);
  //     }
  //   });
  //   isAvailable = await AuthService.isUsernameAvailable(username);
  // }

  void _handleChanges(String username) async {
    setState(() {});
    username = username;
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    siguneduser = user!;

    super.initState();
  }

  bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loging,
      progressIndicator: CircularProgressIndicator(),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'HELLO, ${siguneduser.displayName}',
                            style: const TextStyle(
                                fontSize: 35.0, fontWeight: FontWeight.bold),
                      
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: Color.fromARGB(255, 52, 52, 52)),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: _image !=
                                          null // if the image is not null then the child will be added to the container with ((ICON.PERSON))
                                      ? Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                          width: 120,
                                          height: 120,
                                        )
                                      : Image.network(
                                          '${siguneduser.photoURL}',
                                          fit: BoxFit.cover,
                                          width: 120,
                                          height: 120,
                                        )),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[900]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '+',
                                    style: const TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                
                                  ),
                                ),
                              ),
                              onTap: () {
                                _pickImage();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: textFiled(
                  //       onChanged: (value) {
                  //         setState(() {
                  //           bio = value;
                  //         });
                  //       },
                  //       hintText: "B I O",
                  //       maxLength: 200,
                  //       maxLines: 3,
                  //       obscureText: false,
                  //     )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
child: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width * 0.85,
    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(20)),
  padding: EdgeInsets.all(10),
  child: Text('Next', style: TextStyle(fontSize: 20),),
  ),
),
                        onTap: () async {
                          setState(() {
                            loging = true;
                          });
                            var collection =
                                FirebaseFirestore.instance.collection('users');
                            collection
                                .doc(siguneduser
                                    .uid) // <-- Doc ID where data should be updated.
                                .update({
                                  'bio': bio,
                                }) // <-- Updated data
                                .then((_) => print('Updated'))
                                .catchError(
                                    (error) => print('Update failed: $error'));

                            print('Data added to Firestore');

                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              SlideAnimationRoute(
                                screen: const ChoseTopic_screen(),
                              ),
                            );
                          

                          setState(() {
                            loging = false;
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
