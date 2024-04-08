import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../services/firebaseService.dart';

class LoadingUsers extends StatefulWidget {
  const LoadingUsers({super.key});

  @override
  State<LoadingUsers> createState() => _LoadingUsersState();
}

class _LoadingUsersState extends State<LoadingUsers> {
  int nameIndex = 0;
  int imageIndex = 0;
  late PageController _controller;
  int currentPage = 0;
  late Timer _timer;

  int incres = 0;
  bool searching = false;

  List name = ['mohammed', 'salem', 'shahad', 'fatima', 'abood', 'maram'];

  List image = [
    'https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671157.jpg?w=900&t=st=1710068057~exp=1710068657~hmac=bc8e6cd95ff6878734620e062bda14761474539b17d0f1b5b94c244cff1ec7ee',
  ];

  void getDocId() async {
    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to a collection
    CollectionReference rooms = firestore.collection('users');

    // Get documents from the collection
    QuerySnapshot<Object?> querySnapshot =
        await rooms.orderBy('lastOnline', descending: true).limit(100).get();

    // Process each document in the collection
    for (var doc in querySnapshot.docs) {
      setState(() {
        image.addAll({doc['photoURL']});

        name.addAll({doc['displayName']});
      });
    }

    // Print the list of docIds
    print('Document IDs: $image');
  }

  User? user; // Declare user without initialization
  late Future<DocumentSnapshot> userDataFuture;
  String roomId = '';
  String senderId = '';





  
  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (currentPage < image.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      _controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.4,initialPage: 3);
    _startAutoScroll();

    user = FirebaseAuth.instance.currentUser; // Initialize user in initState
    userDataFuture = getUserData(user!.uid);
    getDocId();
    Timer.periodic(const Duration(microseconds: 400000), (timer) {
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
    _controller.dispose();
    _timer.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: FutureBuilder<DocumentSnapshot>(
                    future: userDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                                radius: 60, backgroundColor: Colors.grey[800]),
                          ],
                        ); // Show a loading indicator while waiting for data
                      }
                      if (!snapshot.hasData) {
                        return const Text(
                            'No data available'); // Handle the case when there is no data
                      }
                      final userData = snapshot.data;
                      if (userData != null) {
                        final photoURL = userData['photoURL'].toString();
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            photoURL,
                          ),
                        );
                      } else {
                        return const Text(
                            'User data is null'); // Handle the case when user data is null
                      }
                    },
                  ),
                ),
              ),
              Lottie.asset('assets/images/loading.json', width: 100),
        Expanded(
          child: SizedBox(
            height: 450,
            child: Center(
              child: PageView.builder(
                padEnds: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: image.length,
                controller: _controller,
                    
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      double value = 1.0;
                      if (_controller.position.haveDimensions) {
                        value = _controller.page! - index;
                        value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                      }
                      return Center(
                        child: SizedBox(
                          height: Curves.easeOut.transform(value) * 150,
                          width: Curves.easeOut.transform(value) * 150,
                          child: Opacity(
                            opacity: currentPage==index ? 1.0 : 0.5, // Adjust opacity based on selection
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(image[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        
              ),
                              ],
          ),
        ),
      ),
    );
  }
}
