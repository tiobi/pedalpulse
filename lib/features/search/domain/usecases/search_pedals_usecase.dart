import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../pedals/domain/entities/pedal_entity.dart';
import '../repositories/search_repository.dart';

class SearchPedalsUseCase {
  final SearchRepository repository;

  SearchPedalsUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<PedalEntity>>> call(
      {required String query}) async {
    return await repository.searchPedals(query: query);
  }
}
