import 'package:dartz/dartz.dart';
import 'package:pedalpulse/core/errors/firestore_database_failure.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_datasource.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestDataSource dataSource;

  RequestRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, Unit>> sendRequest(
      {required RequestEntity requestEntity}) async {
    try {
      await dataSource.sendRequest(requestModel: requestEntity.toModel());
      return const Right(unit);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }
}
