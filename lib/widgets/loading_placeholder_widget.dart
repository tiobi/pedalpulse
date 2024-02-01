import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/managers/color_manager.dart';

class LoadingPlaceholderWidget extends StatelessWidget {
  final double size;
  const LoadingPlaceholderWidget({Key? key, this.size = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.prograssiveDots(
        color: ColorManager.appPrimaryColor,
        size: size,
      ),
    );
  }
}
