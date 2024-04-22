import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/banner_repository.dart';

class IncreaseBannerViewsUseCase {
  final BannerRepository repository;

  IncreaseBannerViewsUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required String uid}) async {
    return await repository.increaseBannerViews(uid: uid);
  }
}
