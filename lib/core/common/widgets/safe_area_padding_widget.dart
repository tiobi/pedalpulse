import 'package:flutter/material.dart';

import '../managers/color_manager.dart';

class SafeAreaPaddingWidget extends StatelessWidget {
  const SafeAreaPaddingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double safeAreaHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;

    return Container(
      color: ColorManager.primaryColorLight,
      height: safeAreaHeight,
    );
  }
}
