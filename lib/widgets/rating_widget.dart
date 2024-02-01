import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:pedalpulse/models/rating_model.dart';
import 'package:pedalpulse/widgets/custom_slider_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../utils/managers/color_manager.dart';

class RatingWidget extends StatefulWidget {
  const RatingWidget({
    Key? key,
    required this.rating,
    required this.uid,
  }) : super(key: key);

  final RatingModel rating;
  final String uid;

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late final RatingModel _rating;
  bool showAnimation = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rating = widget.rating;
  }

  String getLabel(double value) {
    if (value < 20) {
      return "Bad";
    } else if (value < 40) {
      return "Poor";
    } else if (value < 60) {
      return "Average";
    } else if (value < 80) {
      return "Good";
    } else if (value < 100) {
      return "Great";
    } else {
      return "Excellent";
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return VisibilityDetector(
      key: Key(widget.uid),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1) {
          setState(() {
            showAnimation = true;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorManager.primaryColorLight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Overall",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  getLabel(
                    _rating.overall.toDouble(),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            showAnimation
                ? FAProgressBar(
                    currentValue: _rating.overall.toDouble(),
                    maxValue: 100,
                    size: 12,
                    animatedDuration: const Duration(milliseconds: 1500),
                    progressColor:
                        ColorManager.appPrimaryColor.withOpacity(0.8),
                    backgroundColor: Colors.grey,
                  )
                : Container(
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),

            // specific rating
            SizedBox(
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 16),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                ),
                children: [
                  CustomSliderWidget(
                      value: _rating.sound.toDouble(),
                      text: "Sound",
                      onChanged: (_) {}),
                  CustomSliderWidget(
                      value: _rating.accessibility.toDouble(),
                      text: "Accessibility",
                      onChanged: (_) {}),
                  CustomSliderWidget(
                      value: _rating.buildQuality.toDouble(),
                      text: "Build Quality",
                      onChanged: (_) {}),
                  CustomSliderWidget(
                      value: _rating.versatility.toDouble(),
                      text: "Versatility",
                      onChanged: (_) {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
