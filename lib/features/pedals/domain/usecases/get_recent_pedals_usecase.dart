import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/pedal_entity.dart';
import '../repositories/pedal_repository.dart';

class GetRecentPedalsUseCase {
  final PedalRepository repository;

  GetRecentPedalsUseCase({required this.repository});

  Future<Either<Failure, List<PedalEntity>>> call({int limit = 10}) async {
    return repository.getRecentPedals(limit: limit);
  }
}
