import 'package:flutter/widgets.dart';
import 'package:pedalpulse/core/common/widgets/snack_bar_widget.dart';

import '../../domain/entities/banner_entity.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import '../../domain/usecases/increase_banner_views_usecase.dart';

class BannerProvider extends ChangeNotifier {
  List<BannerEntity?> banners = [];
  bool isLoading = false;

  final GetBannersUseCase getBannersUseCase;
  final IncreaseBannerViewsUseCase increaseBannerViewsUseCase;

  BannerProvider({
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
    final bannersOrFailure = await getBannersUseCase.call();

    bannersOrFailure.fold(
      (failure) =>
          CustomSnackBar.showErrorSnackBar(context, 'Unable to get banners'),
      (banners) => banners = banners,
    );

    setLoading(false);
  }
}
