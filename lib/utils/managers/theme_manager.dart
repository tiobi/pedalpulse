import 'package:flutter/material.dart';
import 'package:pedalpulse/utils/managers/color_manager.dart';

class ThemeManager {
  static bool isDarkMode = false;

  static ThemeData getThemeData() {
    // return isDarkMode
    //     ? ThemeData.dark().copyWith(useMaterial3: true)
    //     : ThemeData.light(useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      primaryColor: ColorManager.appPrimaryColor,
      scaffoldBackgroundColor: ColorManager.backgroundColorLight,
    );
  }
}
