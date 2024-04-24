import 'package:flutter/material.dart';

class CustomCircleIconButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  const CustomCircleIconButtonWidget(
      {Key? key, this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.black.withOpacity(0.7),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
