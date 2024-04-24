import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../core/constants/global_variable.keys.dart';

enum AdType { largeBanner, mediumRectangle }

class AdsProvider extends ChangeNotifier {
  BannerAd? largeBannerAd;
  BannerAd? mediumRectangleAd;

  Future<void> loadAds() async {
    final String adUnitId = kIsWeb
        ? ''
        : Platform.isIOS
            ? BANNER_UNIT_ID['ios']!
            : BANNER_UNIT_ID['android']!;

    largeBannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) {
        notifyListeners();
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
    );

    mediumRectangleAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) {
        notifyListeners();
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
    );

    largeBannerAd!.load();
    mediumRectangleAd!.load();
  }
}
