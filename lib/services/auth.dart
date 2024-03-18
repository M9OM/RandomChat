import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/providerauth.dart';
import '/screens/chatList/chatList.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/register_model.dart';


class AuthService {
  //sing up
  //sing up
Future<String> signUp(BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();

User? user = userCredential.user;

var image = ['https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?size=626&ext=jpg','https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671142.jpg?size=626&ext=jpg','https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671157.jpg?w=900&t=st=1710068057~exp=1710068657~hmac=bc8e6cd95ff6878734620e062bda14761474539b17d0f1b5b94c244cff1ec7ee','https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671134.jpg?w=900&t=st=1710068071~exp=1710068671~hmac=61ddfb38f407af33e0a40a60fb2e2012e01d7c3870b4322c0ebd0fada0734f8d','https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671136.jpg?t=st=1710068071~exp=1710068671~hmac=d571b686445167b4cd3749c463ab993ee10f1af8df95127eb0def87e6b87ecfa'];
var name = ['mohammed','messi','noor','shahad','saleh','Marwan','elon'];

// take random str from list
final random = Random();
var ProfileRandom = image[random.nextInt(image.length)];
var nameRandom = name[random.nextInt(name.length)];

    // save user data to Firestore
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'uid': user.uid,
      'displayName': nameRandom.toString(),
      'photoURL': ProfileRandom.toString(),
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });
  final users = Provider.of<ModelsProvider>(context);


    return 'Sign up successful';
  } catch (e) {
    return 'Sign up failed.';
  }
  
}

void signOut()  {
    FirebaseAuth.instance.signOut();

}

}
