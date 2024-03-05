import 'package:flutter/material.dart';

class AppSizeProvider extends ChangeNotifier {
  Size? _size;
  double? _appWidth;
  double? _appHeight;

  double get appWidth => _appWidth ?? 0;
  double get appHeight => _appHeight ?? 0;
  Size get size => _size ?? const Size(0, 0);

  void setAppSize({required BuildContext context}) {
    final Size size = MediaQuery.of(context).size;
    _size = size;
    _appWidth = size.width;
    _appHeight = size.height;

    notifyListeners();
  }
}
