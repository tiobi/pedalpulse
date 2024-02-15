import 'package:flutter/material.dart';

class AppSizeProvider extends ChangeNotifier {
  double _appWidth = 0;
  double _appHeight = 0;

  double get appWidth => _appWidth;
  double get appHeight => _appHeight;

  void setAppSize({required Size size}) {
    _appWidth = size.width;
    _appHeight = size.height;
    notifyListeners();
  }
}
