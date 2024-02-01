import 'package:flutter/foundation.dart';

const String assetPath = 'assets/';
const String imageAssetPath = '${assetPath}images';
const Map<String, String> BANNER_UNIT_ID = kReleaseMode
    ? {
        'ios': 'ca-app-pub-4476914369944882/2987532167',
        'android': 'ca-app-pub-4476914369944882/5677274681',
      }
    : {
        'ios': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-3940256099942544/6300978111',
      };
