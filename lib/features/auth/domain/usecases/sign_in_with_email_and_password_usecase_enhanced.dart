import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';
import '../entities/auth_entity_enhanced.dart';
import '../../data/repositories/firebase_auth_repository_new.dart';

class SignInWithEmailAndPasswordUseCaseEnhanced {
  final FirebaseAuthRepositoryNew _repository;

  SignInWithEmailAndPasswordUseCaseEnhanced({
    required FirebaseAuthRepositoryNew repository,
  }) : _repository = repository;

  Future<Either<Failure, UserCredential>> call({
    required AuthEntityEnhanced authEntity,
  }) async {
    if (!authEntity.isValid) {
      return Left(Failure(message: authEntity.validationError!));
    }

    return await _repository.signInWithEmailAndPassword(
      authEntity: AuthEntity(
        email: authEntity.email.value,
        password: authEntity.password.value,
      ),
    );
  }
}