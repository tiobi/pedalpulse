import 'package:flutter/material.dart';
import 'package:pedalpulse/widgets/loading_placeholder_widget.dart';

import '../utils/managers/color_manager.dart';

class LoadingPedalCardWidget extends StatefulWidget {
  const LoadingPedalCardWidget({
    super.key,
  });

  @override
  State<LoadingPedalCardWidget> createState() => _LoadingPedalCardWidgetState();
}

class _LoadingPedalCardWidgetState extends State<LoadingPedalCardWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double cardWidth = size.width / 2 - 16;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      width: cardWidth,
      height: cardWidth * 1.5,
      decoration: BoxDecoration(
        color: ColorManager.backgroundColorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorManager.backgroundColorLight,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Center(
              child: Container(
                height: cardWidth - 10,
                width: cardWidth - 10,
                color: ColorManager.primaryColorLight,
                padding: const EdgeInsets.all(8.0),
                child: const Center(
                  child: LoadingPlaceholderWidget(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 15,
              width: 50,
              color: ColorManager.primaryColorLight,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 20,
              width: cardWidth - 40,
              color: ColorManager.primaryColorLight,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(
              height: 15,
              width: 60,
              color: ColorManager.primaryColorLight,
            ),
          ),
        ],
      ),
    );
  }
}
