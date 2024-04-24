import 'package:flutter/material.dart';

import '../../../../core/common/managers/color_manager.dart';

class CustomTextButtonWidget extends StatelessWidget {
  final String placeholder;
  final double fontSize;
  final VoidCallback? onTap;

  const CustomTextButtonWidget({
    Key? key,
    required this.placeholder,
    this.onTap,
    this.fontSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        placeholder,
        style: TextStyle(
          color: ColorManager.appSecondaryColor.withOpacity(.8),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
