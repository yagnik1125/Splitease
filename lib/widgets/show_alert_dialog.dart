import 'package:flutter/material.dart';

showAlertDialog({
  required BuildContext context,
  required String message,
  String? btnText,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            message,
            style: const TextStyle(color: Color.fromARGB(255, 33, 131, 243)),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                btnText ?? "OK",
                style: const TextStyle(
                  color: Color.fromARGB(255, 33, 131, 243),
                ),
              ),
            ),
          ],
        );
      });
}
