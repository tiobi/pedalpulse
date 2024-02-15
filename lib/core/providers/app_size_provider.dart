import 'package:flutter/material.dart';

class AppSizeProvider extends ChangeNotifier {
  double _appWidth = 0;
  double _appHeight = 0;

  double get appWidth => _appWidth;
  double get appHeight => _appHeight;

  void setAppSize(double width, double height) {
    _appWidth = width;
    _appHeight = height;
    notifyListeners();
  }
}
