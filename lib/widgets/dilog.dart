  import 'package:flutter/material.dart';

Future<void> dialogBuilder(BuildContext context, {required String text, required Function onTap}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
                final theme = Theme.of(context);

        return AlertDialog(
          content:  Text(
            'Do you want to logout from your account?',style: theme.textTheme.bodyLarge,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.labelLarge,
              ),
              child:  Text('No', style:TextStyle(color: theme.iconTheme.color) ,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.labelLarge,
              ),
              child:  Text('Yes' ,style: TextStyle(color: theme.iconTheme.color),),
              onPressed: () {
                onTap();
              },
            ),
          ],
        );
      },
    );
  }
