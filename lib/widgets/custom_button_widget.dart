import 'package:flutter/material.dart';

import '../utils/managers/color_manager.dart';

class CustomButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String placeholder;
  final bool isLoading;
  final Color color;

  const CustomButtonWidget({
    Key? key,
    this.onTap,
    required this.placeholder,
    this.isLoading = false,
    this.color = ColorManager.appPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : InkWell(
              onTap: onTap,
              child: Center(
                child: Text(
                  placeholder,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }
}
