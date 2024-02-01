import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/global_variable.dart';

enum AdType { largeBanner, mediumRectangle }

class AdMobBannerAdWidget extends StatefulWidget {
  final AdType adType;
  const AdMobBannerAdWidget({Key? key, required this.adType}) : super(key: key);

  @override
  _AdMobBannerAdWidgetState createState() => _AdMobBannerAdWidgetState();
}

class _AdMobBannerAdWidgetState extends State<AdMobBannerAdWidget> {
  BannerAd? _bannerAd;
  AdSize? _adSize;

  bool _isLoading = true;
  int _adHeight = 100;

  final String _bannerAdUnitId = kIsWeb
      ? ''
      : Platform.isIOS
          ? BANNER_UNIT_ID['ios']!
          : BANNER_UNIT_ID['android']!;

  @override
  void initState() {
    super.initState();
    setAdSize();
    loadAd();
  }

  void setAdSize() {
    switch (widget.adType) {
      case AdType.largeBanner:
        _adSize = AdSize.largeBanner;
        break;
      case AdType.mediumRectangle:
        _adSize = AdSize.mediumRectangle;
        break;
    }
  }

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: _adSize!,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            setAdHeight();
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  void setAdHeight() {
    setState(() {
      _adHeight = _bannerAd!.size.height.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      height: _adHeight.toDouble(),
      alignment: Alignment.center,
      child: _isLoading
          ? const SizedBox()
          : Center(child: AdWidget(ad: _bannerAd!)),
    );
  }
}
