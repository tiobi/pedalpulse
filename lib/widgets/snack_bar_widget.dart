import 'package:flutter/material.dart';

class SnackbarWidget extends StatelessWidget {
  final String message;
  const SnackbarWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(message),
    );
  }
}
