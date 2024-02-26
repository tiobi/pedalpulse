import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase({
    required this.repository,
  });

  Future<Either<Failure, UserEntity>> call({
    required UserEntity userEntity,
  }) async {
    return repository.updateUser(userEntity: userEntity);
  }
}
