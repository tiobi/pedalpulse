import 'package:flutter/material.dart';

import '../../../../core/common/managers/color_manager.dart';
import '../../../../core/common/managers/string_manager.dart';

class SocialAuthDividerWidget extends StatelessWidget {
  const SocialAuthDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          const Divider(),
          Center(
            child: Container(
              width: 50,
              color: ColorManager.backgroundColorLight,
              child: const Text(
                AppStringManager.orUppercase,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
