import 'package:flutter/material.dart';

import '../utils/managers/route_manager.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: const Icon(Icons.upload),
          onPressed: () {
            Navigator.pushNamed(context, Routes.uploadPost);
          },
        ),
      ),
    );
  }
}
