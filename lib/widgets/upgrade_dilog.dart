import 'package:chatme/constant/str_extntion.dart';
import 'package:chatme/constant/translate_constat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Upgrade_Dilog extends StatelessWidget {
  const Upgrade_Dilog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Theme.of(context).cardColor),
        child: ListTile(title: Text(TranslationConstants.upgrade_msg_title.t(context)),
        subtitle: Text(TranslationConstants.upgrade_msg_subtitle.t(context)),
        leading:Container( 
          
          padding:EdgeInsets.all(15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Theme.of(context).primaryColor), child:Text(TranslationConstants.upgrade.t(context),style: TextStyle(color: Theme.of(context).cardColor,fontWeight: FontWeight.bold
          ),))
        
        ),
      )
    );
  }
}
