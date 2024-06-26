import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase({
    required this.repository,
  });

  Future<Either<Failure, UserEntity>> call({
    required String uid,
  }) async {
    return repository.getUser(uid: uid);
  }
}
