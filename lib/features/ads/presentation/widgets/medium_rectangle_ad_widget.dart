import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../injection_container.dart';
import '../providers/ads_provider.dart';

class MediumRectangleAdWidget extends StatelessWidget {
  const MediumRectangleAdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdsProvider adsProvider = getIt<AdsProvider>();

    return adsProvider.mediumRectangleAd == null
        ? const SizedBox(height: 100)
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            height: adsProvider.mediumRectangleAd!.size.height.toDouble(),
            alignment: Alignment.center,
            child: Center(
              child: AdWidget(ad: adsProvider.mediumRectangleAd!),
            ),
          );
  }
}
