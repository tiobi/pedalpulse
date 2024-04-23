import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../pedals/domain/entities/pedal_entity.dart';

class SearchPedalsUseCase {
  Future<Either<Failure, List<PedalEntity>>> call(
      {required String query}) async {
    throw UnimplementedError();
    // return const Right([]);
  }
}
