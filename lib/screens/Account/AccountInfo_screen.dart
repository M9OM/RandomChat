import 'package:chatme/constant/assets_constants.dart';
import 'package:chatme/constant/str_extntion.dart';
import 'package:chatme/constant/translate_constat.dart';
import 'package:chatme/provider/DarktModeProvider.dart';
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
  @override
  void initState() {
    final users = Provider.of<ModelsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataAdmin = Provider.of<DataProvider>(context, listen: false);

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title:Text(TranslationConstants.account_Info.t(context)) ,),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                shape: Border(
                  bottom: BorderSide(width: 1, color: theme.dividerColor),
                ),
                title: Text(TranslationConstants.email.t(context)),
                subtitle: Text(dataAdmin.email.toString()),
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
                  bottom: BorderSide(width: 1, color: theme.dividerColor),
                ),
                title: Text(TranslationConstants.interests.t(context)),
                subtitle: Text(dataAdmin.interest.join(',')),
                leading: SvgPicture.asset(
                  AssetsConstants.kiss,
                  width: 22,
                  color: theme.iconTheme.color,
                ),
              ),
            ),
          ],
        ));
  }
}
