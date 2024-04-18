import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/banner_entity.dart';
import '../repositories/banners_repository.dart';

class GetBannersUseCase {
  BannersRepository repository;

  GetBannersUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<BannerEntity>>> call() async {
    return await repository.getBanners();
  }
}
