import 'package:dartz/dartz.dart';
import 'package:pedalpulse/core/errors/failure.dart';

import '../../../pedals/domain/entities/pedal_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<PedalEntity>>> searchPedals({
    required String query,
  });
}
