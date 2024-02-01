import 'package:flutter/material.dart';

class DraggerWidget extends StatelessWidget {
  const DraggerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 16, bottom: 8),
        width: 100,
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black45,
        ),
      ),
    );
  }
}
