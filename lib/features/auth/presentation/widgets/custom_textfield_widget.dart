// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class CustomTextfieldWidget extends StatefulWidget {
  TextEditingController? controller;
  IconButton? prefixIconButton;
  IconButton? suffixIconButton;
  final String placeholder;
  final bool isObscure;
  final int? maxLength;
  final Function? onSubmitted;

  CustomTextfieldWidget({
    Key? key,
    required this.placeholder,
    this.controller,
    this.isObscure = false,
    this.maxLength,
    this.prefixIconButton,
    this.suffixIconButton,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<CustomTextfieldWidget> createState() => _CustomTextfieldWidgetState();
}

class _CustomTextfieldWidgetState extends State<CustomTextfieldWidget> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    isVisible = widget.isObscure;
  }

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          constraints: const BoxConstraints(
            minHeight: 50,
          ),
          child: TextField(
            onSubmitted: (value) {
              if (widget.onSubmitted != null) {
                widget.onSubmitted!(value);
              }
            },
            controller: widget.controller,
            obscureText: isVisible,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              suffixIcon: widget.suffixIconButton ?? const SizedBox(),
              fillColor: Colors.grey[200],
              filled: true,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: widget.placeholder,
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
        ),
        widget.isObscure
            ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 20,
                    top: 20,
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: toggleVisibility,
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
