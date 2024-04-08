import 'package:chatme/provider/providerauth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../../provider/DarktModeProvider.dart';
import '../../../services/firebaseService.dart';

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
    final adminData = Provider.of<DataProvider>(context);

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
                       ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(adminData.avatarUrl),
                        ),
                        title: Text(
                          adminData.name,
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Text(adminData.email),
                      )])])
                    
      ),
    );
  }
}
