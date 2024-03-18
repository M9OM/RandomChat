import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

import '../../services/firebaseService.dart';

class LoadingUsers extends StatefulWidget {
  const LoadingUsers({super.key});

  @override
  State<LoadingUsers> createState() => _LoadingUsersState();
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

class _LoadingUsersState extends State<LoadingUsers> {
    User? user; // Declare user without initialization
  late Future<DocumentSnapshot> userDataFuture;
String roomId ='';
String senderId ='';
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Initialize user in initState
    userDataFuture = getUserData(user!.uid);

    int i = 0;
    Timer.periodic(Duration(microseconds: 300000), (timer) {
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[800]
                ),
           
              ],
            ); // Show a loading indicator while waiting for data
                    }
                    if (!snapshot.hasData) {
                      return Text(
                          'No data available'); // Handle the case when there is no data
                    }
                    final userData = snapshot.data;
                    if (userData != null) {
                      final photoURL = userData['photoURL'].toString();
                      return CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(photoURL),
                      );
                    } else {
                      return Text(
                          'User data is null'); // Handle the case when user data is null
                    }
                  },
                ),
                Text(
                  'You',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Lottie.network(
                'https://lottie.host/dbb7cba1-d7c4-4379-823b-2ea49e6aa615/LyR13Xz1Cj.json',
                width: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    image[imageIndex].toString(),
                  ),
                ),
                Text(
                  name[imageIndex],
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ],
        ),
      ),);
  }
}