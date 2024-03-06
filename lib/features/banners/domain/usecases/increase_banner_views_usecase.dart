import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/banners/domain/repositories/banners_repository.dart';

import '../../../../core/errors/failure.dart';

class IncreaseBannerViewsUseCase {
  final BannersRepository repository;

  IncreaseBannerViewsUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required String uid}) async {
    return await repository.increaseBannerViews(uid: uid);
  }
}
