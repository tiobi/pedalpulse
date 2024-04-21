import 'package:flutter/material.dart';

class CustomDynamicHeightTextfieldWidget extends StatelessWidget {
  final TextEditingController textController;
  final String? placeholder;
  final int maxLength;

  final double _minHeight = 2000;

  const CustomDynamicHeightTextfieldWidget({
    super.key,
    required this.textController,
    required this.maxLength,
    this.placeholder = '',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicHeight(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            height: constraints.maxHeight < _minHeight
                ? _minHeight
                : constraints.maxHeight,
            child: TextField(
              controller: textController,
              maxLines: null, // Set maxLines to null for multiline support
              maxLength: maxLength,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                fillColor: Colors.grey[200],
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelText: placeholder,
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
