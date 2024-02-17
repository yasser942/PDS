import 'package:flutter/material.dart';

void showAlert(BuildContext context, String Message ,String title) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title:  Text(title),
      content: Text(Message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
