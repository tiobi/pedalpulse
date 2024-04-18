import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/banners/domain/repositories/banners_repository.dart';

import '../../../../core/errors/banner_failure.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/banner_entity.dart';
import '../datasources/banners_datasource.dart';

class BannersRepositoryImpl extends BannersRepository {
  final BannersDataSource dataSource;

  BannersRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    try {
      final List<BannerEntity> banners = await dataSource.getBanners();

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
