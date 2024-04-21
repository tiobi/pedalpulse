import 'package:dartz/dartz.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firestore_database_failure.dart';
import 'package:pedalpulse/features/pedals/data/datasources/pedal_firestore_datasource.dart';
import 'package:pedalpulse/features/pedals/domain/entities/pedal_entity.dart';
import 'package:pedalpulse/features/pedals/domain/repositories/pedal_repository.dart';

import '../models/pedal_model.dart';

class PedalRepositoryImpl extends PedalRepository {
  final PedalFirestoreDataSource pedalDataSource;

  PedalRepositoryImpl({required this.pedalDataSource});

  @override
  Future<Either<Failure, List<PedalEntity>>> getPopularPedals(
      {int limit = 10}) async {
    try {
      final List<PedalModel> pedalModels =
          await pedalDataSource.getPopularPedals(limit: limit);

      final List<PedalEntity> pedalEntities =
          pedalModels.map((e) => e.toEntity()).toList();

      return Right(pedalEntities);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PedalEntity>>> getRecentPedals(
      {int limit = 10}) async {
    try {
      final List<PedalModel> pedalModels =
          await pedalDataSource.getRecentPedals(limit: limit);

      final List<PedalEntity> pedalEntities =
          pedalModels.map((e) => e.toEntity()).toList();

      return Right(pedalEntities);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }
}
