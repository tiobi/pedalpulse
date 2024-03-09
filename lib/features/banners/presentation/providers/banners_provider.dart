import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:pedalpulse/features/banners/domain/usecases/get_banners_usecase.dart';
import 'package:pedalpulse/features/banners/domain/usecases/increase_banner_views_usecase.dart';

import '../../domain/entities/banners_entity.dart';

class BannersProvider extends ChangeNotifier {
  final List<BannerEntity> _bannerList = [];

  List<BannerEntity> get bannerList => _bannerList;

  final GetBannersUseCase getBannersUseCase;
  final IncreaseBannerViewsUseCase increaseBannerViewsUseCase;

  BannersProvider({
    required this.getBannersUseCase,
    required this.increaseBannerViewsUseCase,
  });
}
