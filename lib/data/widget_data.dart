import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vext_app/styles/styles.dart';

class WidgetData {
  Widget infoDialog({
    required BuildContext context,
    required String title,
    required String body,
  }) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.start,
          style: Styles.title_text,
        ),
        content: Text(
          body,
          textAlign: TextAlign.start,
          style: Styles.body_text,
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'OK',
              style: TextStyle(color: Styles.darkGreen),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.start,
          style: Styles.title_text,
        ),
        content: Text(
          body,
          textAlign: TextAlign.start,
          style: Styles.body_text,
        ),
        actions: [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: Styles.darkGreen),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }
  }
}
