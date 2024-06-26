import 'package:chatme/constant/str_extntion.dart';
import 'package:chatme/screens/home/drawer.dart';
import 'package:chatme/screens/home/layout/card/card_users.dart';
import 'package:chatme/screens/registration/register_screen.dart';
import 'package:chatme/services/firebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constant/translate_constat.dart';
import '../../provider/DarktModeProvider.dart';
import '../../provider/providerauth.dart';
import '../../services/google_auth.dart';
import '../../widgets/dilog.dart';
import '../addGroup/addGroupDilog.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'appbar.dart';
import 'layout/card/card_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  List<String> docId = ['e', 'e'];
  late Future<DocumentSnapshot> getAdminData;
  final AdvancedDrawerController _drawerController =
      new AdvancedDrawerController();
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
    final darktMode = Provider.of<DataProvider>(context);
    final lang = Provider.of<DataProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: theme.cardColor,
        child: AdvancedDrawerShow(
          isDark: darktMode.isDarkMode,
          darkModeTap: () {
            darktMode.isDarkMode
                ? darktMode.toggleDarkMode(false)
                : darktMode.toggleDarkMode(true);
          },
          logoutTap: () {
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
            }, text: TranslationConstants.want_to_logOut_msg.t(context));
          },
          languageTap: () {
            lang.locale == 'en'
                ? lang.changeLanguage('ar')
                : lang.changeLanguage('en');
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyApbbar(drawerTap: () {
            _openDrawer();
          }),
          LiquidPullToRefresh(
            onRefresh: () async {
              HapticFeedback.mediumImpact();

              getDocId();
            }, // refresh callback
            color: theme.cardColor,
            animSpeedFactor: 2.0,
            backgroundColor: theme.primaryColor,
            springAnimationDurationInMilliseconds: 800,
            child: Expanded(
                child: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(dataProvider.avatarUrl),
                                radius: 25,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateTime.now().hour < 12
                                        ? TranslationConstants.good_morning.t(context)
                                        : TranslationConstants.good_evening.t(context),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  Text(dataProvider.name.toString(),
                                      style: const TextStyle(fontSize: 20))
                                ],
                              ),
                            ],
                          ),
                    Row(
                      children: [
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.add,
                              color: theme.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
               Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  TranslationConstants.friends.t(context),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 138,
                child: StreamBuilder<QuerySnapshot>(
                    stream: getListOfUsers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 5,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CardUserLoading(
                              onTap: () {},
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

                          String displayName =
                              profileData[index]['displayName'];
                          String photoURL = profileData[index]['photoURL'];

                          return profileData[index]['uid'] != user.usersId
                              ? CardUsers(
                                  onTap: () {},
                                  isOnline: isOnline,
                                  photoURL: photoURL,
                                  displayName: displayName)
                              : const SizedBox();
                        },
                      );
                    }),
              )
            ])),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
