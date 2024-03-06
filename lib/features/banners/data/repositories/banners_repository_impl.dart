import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/banners/domain/repositories/banners_repository.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/banners_entity.dart';
import '../datasources/banners_datasource.dart';

class BannersRepositoryImpl extends BannersRepository {
  final BannersDataSource dataSource;

  BannersRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> increaseBannerViews({required String uid}) {
    throw UnimplementedError();
  }
}
