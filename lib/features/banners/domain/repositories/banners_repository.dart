import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/banners_entity.dart';

abstract class BannersRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners();
  Future<Either<Failure, Unit>> increaseBannerViews({required String uid});
}
