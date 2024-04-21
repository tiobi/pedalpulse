import 'package:flutter/widgets.dart';
import 'package:pedalpulse/core/common/widgets/snack_bar_widget.dart';
import 'package:pedalpulse/features/banners/domain/usecases/get_banners_usecase.dart';
import 'package:pedalpulse/features/banners/domain/usecases/increase_banner_views_usecase.dart';

import '../../domain/entities/banner_entity.dart';

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

  void getBanners({
    required BuildContext context,
  }) async {
    setLoading(true);
    final result = await getBannersUseCase.call();

    result.fold(
      (l) => CustomSnackBar.showErrorSnackBar(context, 'Unable to get banners'),
      (r) => bannerList = r,
    );

    setLoading(false);
  }
}
