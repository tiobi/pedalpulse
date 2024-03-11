import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pedalpulse/features/banners/domain/usecases/get_banners_usecase.dart';
import 'package:pedalpulse/features/banners/domain/usecases/increase_banner_views_usecase.dart';

import '../../domain/entities/banners_entity.dart';

class BannersProvider extends ChangeNotifier {
  List<BannerEntity?> bannerList = [];
  bool isLoading = false;

  final GetBannersUseCase getBannersUseCase;
  final IncreaseBannerViewsUseCase increaseBannerViewsUseCase;

  BannersProvider({
    required this.getBannersUseCase,
    required this.increaseBannerViewsUseCase,
  });

  void setLoading(bool value) {
    notifyListeners();
  }
}
