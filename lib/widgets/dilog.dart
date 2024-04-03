  import 'package:chatme/constant/str_extntion.dart';
import 'package:flutter/material.dart';

import '../constant/translate_constat.dart';

Future<void> dialogBuilder(BuildContext context, {required String text, required Function onTap}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
                final theme = Theme.of(context);

        return AlertDialog(
          content:  Text(
            text,style: theme.textTheme.bodyLarge,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.labelLarge,
              ),
              
              child:  Text(TranslationConstants.no.t(context), style:TextStyle(color: theme.iconTheme.color) ,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.labelLarge,
              ),
              child:  Text(TranslationConstants.yes.t(context),style: TextStyle(color: theme.iconTheme.color),),
              onPressed: () {
                onTap();
              },
            ),
          ],
        );
      },
    );
  }
