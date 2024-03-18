import 'package:flutter/material.dart';

class Dilog {
  double _size = 40.0;
  Future<void> dialogBuilder(
      BuildContext context, Function black, Function blue, Function red) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      red();
                    },
                    child: Icon(
                      Icons.circle,
                      color: Colors.orange,
                      size: _size,
                    )),
                InkWell(
                    onTap: () {
                      blue();
                    },
                    child: Icon(Icons.circle,
                        color: Colors.indigoAccent, size: _size)),
                InkWell(
                    onTap: () {
                      black();
                    },
                    child: Icon(Icons.circle,
                        color: Color.fromARGB(255, 73, 73, 73), size: _size)),
              ],
            ),
          ],
        );
      },
    );
  }
}
