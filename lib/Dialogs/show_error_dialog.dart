import 'package:flutter/material.dart';

showErrorDialog(BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Oops. Something went wrong!!!"),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "OK",
            ),
          ),
        ],
      );
    },
  );
}
