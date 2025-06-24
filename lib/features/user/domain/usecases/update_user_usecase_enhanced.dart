import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';
import '../entities/user_entity_enhanced.dart';
import '../../data/repositories/user_repository_new.dart';

class UpdateUserUseCaseEnhanced {
  final UserRepositoryNew _repository;

  UpdateUserUseCaseEnhanced({
    required UserRepositoryNew repository,
  }) : _repository = repository;

  Future<Either<Failure, UserEntity>> call({
    required UserEntityEnhanced userEntity,
  }) async {
    if (!userEntity.isValid) {
      return Left(Failure(message: userEntity.validationError!));
    }

    final basicUserEntity = UserEntity(
      uid: userEntity.uid,
      username: userEntity.username.value,
      email: userEntity.email.value,
      profileImageUrl: userEntity.profileImageUrl.value,
      backgroundImageUrl: userEntity.backgroundImageUrl.value,
      bio: userEntity.bio.value,
      joinedAt: userEntity.joinedAt,
    );

    return await _repository.updateUser(userEntity: basicUserEntity);
  }
}