// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pedalpulse/utils/managers/color_manager.dart';

class CustomSliderWidget extends StatefulWidget {
  final double value;
  final String text;
  final Function onChanged;
  const CustomSliderWidget({
    Key? key,
    required this.value,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSliderWidgetState createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
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
    return SizedBox(
      child: Column(
        children: [
          Slider(
            value: widget.value,
            divisions: 5,
            min: 0,
            max: 100,
            label: getLabel(widget.value),
            onChanged: (value) {
              widget.onChanged(value);
            },
            activeColor: ColorManager.appSecondaryColor,
            inactiveColor: ColorManager.primaryColorLight,
          ),
          Text(widget.text)
        ],
      ),
    );
  }
}
