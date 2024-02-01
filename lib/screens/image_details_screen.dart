import 'package:flutter/material.dart';

class ImageDetailsScreen extends StatelessWidget {
  final Widget widget;
  const ImageDetailsScreen({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widget),
    );
  }
}
