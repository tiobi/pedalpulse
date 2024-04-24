import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/search/domain/repositories/search_repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../pedals/domain/entities/pedal_entity.dart';
import '../datasources/search_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDataSource dataSource;

  SearchRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<PedalEntity>>> searchPedals({
    required String query,
  }) async {
    try {
      final pedals = await dataSource.searchPedals(query: query);
      return Right(pedals);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
