import 'package:flutter/material.dart';

const String snackBarTitleAwesome = 'Awesome!';
const String snackBarTitleError = 'Oh No!';

class CustomSnackBar {
  static void showErrorSnackBar(BuildContext context, String message) {
    // final String snackBarMessage = message.split(':')[1];
    final String snackBarMessage = message;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 237, 154, 29),
        elevation: 0,
        content: Text(
          snackBarMessage,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 46, 204, 112),
        elevation: 0,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
