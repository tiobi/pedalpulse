import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/request_entity.dart';
import '../repositories/request_repository.dart';

class SendRequestUseCase {
  final RequestRepository repository;

  SendRequestUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required RequestEntity requestEntity,
  }) async {
    return repository.sendRequest(requestEntity: requestEntity);
  }
}
