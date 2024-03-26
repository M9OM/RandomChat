import 'package:chatme/screens/ChangeScreens.dart';
import 'package:chatme/screens/profileSetup/profile_bio_setup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../animation/side_animatin_route.dart';
import '../model/register_model.dart';
import '../provider/providerauth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthServices {
  static Future<UserCredential> signInWithGoogle(BuildContext context) async {
    bool logding = false;
    logding = true;
    final users = Provider.of<ModelsProvider>(context, listen: false);

    Future<bool> isEmailAvailable(String? email) async {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      return snapshot.docs.isEmpty;
    }

    Future<String?> uidOfLogin(String? email) async {
      if (email == null) {
        return null; // or handle the case where email is null
      }

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        return null; // or handle the case where no user with the given email is found
      }

      return snapshot.docs[0].id;
    }

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    print('${_googleSignIn.currentUser?.email}');

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {}

    final String? userIDD =
        await uidOfLogin('${_googleSignIn.currentUser?.email}');

    final bool isAvailable = await isEmailAvailable(user?.email!);
    print(user?.email);
    if (isAvailable && userIDD == null) {
      users.setCurrentModel(user!.uid);

      Register register = Register(
        displayName: user.displayName,
        email: user.email,
        uid: user.uid,
        photoURL: user.photoURL,
        lastOnline: Timestamp.now(),
        createdAt: Timestamp.now(),
        interest: [],
      );

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference registerCollection =
          firestore.collection('users');
      Map<String, dynamic> registerData = register.toFirestore();
      await registerCollection.doc(user.uid).set(registerData);

      Navigator.pushReplacement(
        context,
        SlideAnimationRoute(
          screen: const profileAvatar(),
        ),
      );
    } else {
      users.setCurrentModel(userIDD!);

      Navigator.pushReplacement(
        context,
        SlideAnimationRoute(
          screen: const ChangeScreen(),
        ),
      );
    }

    logding = false;
    return authResult;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
