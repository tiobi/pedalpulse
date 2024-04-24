import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/request_entity.dart';

abstract class RequestRepository {
  Future<Either<Failure, Unit>> sendRequest({
    required RequestEntity requestEntity,
  });
}
