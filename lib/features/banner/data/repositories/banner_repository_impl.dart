import 'package:dartz/dartz.dart';

import '../../../../core/errors/banner_failure.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_firestore_datasource.dart';
import '../models/banner_model.dart';

class BannerRepositoryImpl extends BannerRepository {
  final BannerFirestoreDataSource dataSource;

  BannerRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    try {
      final List<BannerModel> bannerModels = await dataSource.getBanners();

      final List<BannerEntity> banners =
          bannerModels.map((model) => model.toEntity()).toList();

      return Right(banners);
    } catch (e) {
      return Left(BannerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> increaseBannerViews(
      {required String uid}) async {
    try {
      await dataSource.increaseBannerViews(uid: uid);
      return const Right(unit);
    } catch (e) {
      return Left(BannerFailure(message: e.toString()));
    }
  }
}
