import 'package:flutter/material.dart';

class Wqer extends StatelessWidget {
  final uid;
  const Wqer({Key? key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(uid),
      ),
    );
  }
}
