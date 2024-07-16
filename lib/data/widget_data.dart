import 'package:flutter/material.dart';
import 'package:vext_app/styles/styles.dart';

class WidgetData {
  AlertDialog infoDialog({
    required BuildContext context,
    required String title,
    required String body,
  }) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'OK',
            style: Styles.subtitle_text,
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      titleTextStyle: Styles.drawer_text.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      contentTextStyle: Styles.body_text.copyWith(color: Colors.black),
    );
  }
}
