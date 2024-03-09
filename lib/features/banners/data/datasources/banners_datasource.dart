import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/banners/domain/entities/banners_entity.dart';

abstract class BannersDataSource {
  Future<List<BannerEntity>> getBanners();
  Future<Unit> increaseBannerViews({required String uid});
}