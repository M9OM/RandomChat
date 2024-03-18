import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
ClipRRect(
  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
  child: Image.asset('assets/images/forpay.jpg')),
SizedBox(height: 20,),
Container(
  alignment: Alignment.center,
  child: Text('Subscription Offer for Messaging 1000 Random Individuals',style: TextStyle(fontSize: 17), textAlign: TextAlign.center,)),
  SizedBox(height: 15,),

  Text('\$5 ',style: TextStyle(fontSize: 33),),

SizedBox(height: 20,),

          Container(
            padding:EdgeInsets.all(15) ,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.blueAccent),
            child: Text('Subscripe',style: TextStyle(fontSize: 16),),),
        ],
      ),
    );
  }
}
