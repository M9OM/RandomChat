import 'package:flutter/material.dart';

class boutton_Icon extends StatefulWidget {
  const boutton_Icon({super.key, required this.hintText, required this.onTap,required this.iconPath,});

  final String hintText;
    final String iconPath;

  final Function onTap;
  @override
  State<boutton_Icon> createState() => _boutton_IconState();
}

// ignore: camel_case_types
class _boutton_IconState extends State<boutton_Icon> {
  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      radius: 15,
      onTap: () {
        widget.onTap();
      },
      
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 20,),
        decoration: BoxDecoration(

color: theme.primaryColor,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment : MainAxisAlignment.center,

          children: [
            Image.asset(widget.iconPath,width: 35,color: theme.iconTheme.color,
        ),
        const SizedBox(width: 20,),
            Text(
              widget.hintText,
              textAlign: TextAlign.center,


              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


// hintText + onTap 