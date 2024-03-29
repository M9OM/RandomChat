import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyApbbar extends StatelessWidget {
  const MyApbbar({super.key, required this.drawerTap});
final Function drawerTap;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                InkWell(
                  onTap: () {
                    drawerTap();
                  },
                  child: const Icon(Icons.menu),
                ),
              ])
            ])));
  }
}
