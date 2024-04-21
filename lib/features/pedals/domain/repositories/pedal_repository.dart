import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/pedal_entity.dart';

abstract class PedalRepository {
  Future<Either<Failure, List<PedalEntity>>> getPopularPedals({int limit = 10});

  Future<Either<Failure, List<PedalEntity>>> getRecentPedals({int limit = 10});
}
