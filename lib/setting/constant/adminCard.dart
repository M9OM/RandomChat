import 'package:chatme/provider/providerauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../provider/DarktModeProvider.dart';
import '../../services/firebaseService.dart';

class AdminCard extends StatefulWidget {
  const AdminCard({super.key});

  @override
  State<AdminCard> createState() => _AdminCardState();
}

late Future<DocumentSnapshot> getAdminData;

class _AdminCardState extends State<AdminCard> {
  @override
  void initState() {
    final user = Provider.of<ModelsProvider>(context, listen: false);

    getAdminData = getUserData(user.usersId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: screenWidth * 0.9,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: theme.cardColor, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title

            Column(
              children: [
                FutureBuilder<DocumentSnapshot>(
                    future: getAdminData,
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                        leading: CircleAvatar(
                        ),
                        title: Text(
                          '...',
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Text('@'),
                      ); // Or any other loading indicator
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
                      var name = adminData['displayName'];
                      var email = adminData[
                          'email']; // Assuming 'photoURL' is the key in the admin data map

                      // Assuming 'photoURL' is the key in the admin data map

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(photoURL),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Text(email),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
