import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

const String snackBarTitleAwesome = 'Awesome!';
const String snackBarTitleError = 'Oh No!';

class CustomSnackBar {
  static void showErrorSnackBar(BuildContext context, String message) {
    // final String snackBarMessage = message.split(':')[1];
    final String snackBarMessage = message;

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    final String snackBarMessage = message.split(':')[1];

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: snackBarTitleError,
        message: snackBarMessage,
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
