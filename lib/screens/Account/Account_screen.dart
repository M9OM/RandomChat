import 'package:chatme/constant/assets_constants.dart';
import 'package:chatme/constant/str_extntion.dart';
import 'package:chatme/constant/translate_constat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../provider/providerauth.dart';
import '../../services/firebaseService.dart';
import '../setting/constant/adminCard.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<DocumentSnapshot> getAdminData;

  @override
  void initState() {
    final users = Provider.of<ModelsProvider>(context, listen: false);
    getAdminData = getUserData(users.usersId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: getAdminData,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
child: CircularProgressIndicator(),            ); // Or any other loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Text(
                'No admin data available'); // Or handle the case when data is not available
          }

          var adminData = snapshot.data!.data()! as Map<String, dynamic>;
          var interest = adminData['interest'];
          var email = adminData['email'];

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          TranslationConstants.account_Info.t(context),
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: Border(
                          bottom: BorderSide(
                              width: 1, color: theme.dividerColor),
                        ),
                        title: Text(TranslationConstants.email.t(context)),
                        subtitle: Text(user!.email.toString()),
                        leading: SvgPicture.asset(
                          AssetsConstants.google,
                          width: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        shape: Border(
                          bottom: BorderSide(
                              width: 1, color: theme.dividerColor),
                        ),
                        title:
                            Text(TranslationConstants.interests.t(context)),
                        subtitle: Text(interest.join(',')),
                        leading: SvgPicture.asset(
                          AssetsConstants.kiss,
                          width: 22,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
