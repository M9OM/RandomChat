import 'package:chatme/constant/assets_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class AdvancedDrawerShow extends StatelessWidget {
  const AdvancedDrawerShow({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
    ListTile(
      
      leading: Image.asset(AssetsConstants.homeIcon,width: 30,color: Colors.blue,),
      title:Text('Title',style: TextStyle(fontFamily: 'Orbitron'),),
      ),
ListTile(
      
      leading: Image.asset(AssetsConstants.notifictionIcon,width: 30,color: Colors.blue,),
      title:Text('Title',style: TextStyle(fontFamily: 'Orbitron'),),
      ),ListTile(
      
      leading: Image.asset(AssetsConstants.homeIcon,width: 30,color: Colors.blue,),
      title:Text('Title',style: TextStyle(fontFamily: 'Orbitron'),),
      ),    
    
      ],),
    );
  }
}