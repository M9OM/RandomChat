import 'package:chatme/screens/home/drawer.dart';
import 'package:chatme/screens/registration/register_screen.dart';
import 'package:chatme/services/firebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/DarktModeProvider.dart';
import '../../provider/providerauth.dart';
import '../../services/google_auth.dart';
import '../../widgets/dilog.dart';
import '../addGroup/addGroupDilog.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> docId = ['e', 'e'];
  late Future<DocumentSnapshot> getAdminData;
final AdvancedDrawerController _drawerController = new AdvancedDrawerController();  
  Stream<QuerySnapshot> getListUsersFriends(List uid) {
    setState(() {
      getDocId();
    });
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('lastOnline', descending: true)
        .where('uid', whereIn: uid)
        .snapshots();
  }

  void getDocId() async {
    final user = Provider.of<ModelsProvider>(context, listen: false);

    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to a collection
    CollectionReference rooms = firestore.collection('rooms');

    // Get documents from the collection
    QuerySnapshot<Object?> querySnapshot = await rooms
        .orderBy('timestamp', descending: true)
        .where('userId', arrayContainsAny: [user.usersId, user.usersId])
        .limit(20)
        .get();

    // Process each document in the collection
    for (var doc in querySnapshot.docs) {
      // Access data from each document
      // String otherUserId = doc['userId'][0] == user.usersId
      //     ? doc['userId'][1]
      //     : doc['userId'][0];

      setState(() {
        docId.addAll({
          doc['userId'][0] == user.usersId ? doc['userId'][1] : doc['userId'][0]
        });
      });
    }
    getListOfUsers = getListUserswhere(docId);

    // Print the list of docIds
    print('Document IDs: $docId');
  }

  late Stream<QuerySnapshot> getListOfUsers;
  @override
  void initState() {
    final user = Provider.of<ModelsProvider>(context, listen: false);

    getListOfUsers = getListUsersFriends(docId);
    getAdminData = getUserData(user.usersId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ModelsProvider>(context);
    final theme = Theme.of(context);
    final darktMode = Provider.of<DarktModeProvider>(context);

    return AdvancedDrawer(
      backdropColor: Theme.of(context).canvasColor,
      controller: _drawerController,
      drawer: SafeArea(child: AdvancedDrawerShow()),
      child: Scaffold(
        body: LiquidPullToRefresh(
          onRefresh:() async {
            getDocId();
          }, 	// refresh callback
        color:theme.cardColor,
        animSpeedFactor : 2.0,
        backgroundColor:theme.primaryColor,
      springAnimationDurationInMilliseconds : 800,
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                            future: getAdminData,
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // Or any other loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.data() == null) {
                                return const Text(
                                    'No admin data available'); // Or handle the case when data is not available
                              }
        
                              var adminData = snapshot.data!.data()! as Map<String,
                                  dynamic>; // Explicitly cast to Map<String, dynamic>
                              var photoURL = adminData[
                                  'photoURL']; // Assuming 'photoURL' is the key in the admin data map
                              var name = adminData[
                                  'displayName']; // Assuming 'photoURL' is the key in the admin data map
        
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _drawerController.showDrawer();

                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(photoURL),
                                      radius: 25,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateTime.now().hour < 12
                                            ? 'Good Morning'
                                            : 'Good Evening',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                      Text(name.toString(),
                                          style: const TextStyle(fontSize: 20))
                                    ],
                                  ),
                                ],
                              );
                            }),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                dialogBuilder(context, onTap: () async {
                                  await AuthServices.signOut();
                                  user.setCurrentModel('');
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const register_screen(),
                                    ),
                                    (Route<dynamic> route) =>
                                        false, // This predicate always returns false, so it will remove all routes
                                  );
                                }, text: '');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.logout_outlined),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () async {
        //  AuthService().signOut();
        
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddGroupDialog(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {

                                
                                darktMode.isDarkMode
                                    ? darktMode.toggleDarkMode(false)
                                    : darktMode.toggleDarkMode(true);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(darktMode.isDarkMode
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Friends',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 135,
                child: StreamBuilder<QuerySnapshot>(
                    stream: getListOfUsers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              theme.scaffoldBackgroundColor,
                                        ),
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 3,
                                                color: const Color.fromARGB(
                                                    255, 41, 41, 41)),
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(''),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        ;
                      }
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Error: ${snapshot.error}');
                      }
        
                      var profileData = snapshot.data!.docs;
        
        // print('$isOnline ${DateTime.now().difference(lastOnlineDateTime)}');
        
                      return ListView.builder(
                        itemCount: profileData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Timestamp lastOnlineTimestamp =
                              profileData[index]['lastOnline'];
                          DateTime lastOnlineDateTime =
                              lastOnlineTimestamp.toDate();
                          bool isOnline =
                              DateTime.now().difference(lastOnlineDateTime) <
                                  const Duration(minutes: 2);
        
                          return profileData[index]['uid'] != user.usersId
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  profileData[index]['photoURL']),
                                              backgroundColor:
                                                  theme.scaffoldBackgroundColor,
                                            ),
                                            isOnline
                                                ? Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 3,
                                                        color: theme.cardColor,
                                                      ),
                                                      color: Colors.green,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 3,
                                                        color: theme.cardColor,
                                                      ),
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              profileData[index]['displayName']),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
    
            ],
          ),
        ),
      ),
    );
  }
}
