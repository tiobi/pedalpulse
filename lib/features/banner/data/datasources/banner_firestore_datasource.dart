import 'package:dartz/dartz.dart';

import '../models/banner_model.dart';

abstract class BannerFirestoreDataSource {
  Future<List<BannerModel>> getBanners();
  Future<Unit> increaseBannerViews({required String uid});
}
