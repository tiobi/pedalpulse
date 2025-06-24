import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';
import '../entities/auth_entity_enhanced.dart';
import '../value_objects/password.dart';
import '../../data/repositories/firebase_auth_repository_new.dart';

class SignUpWithEmailAndPasswordUseCaseEnhanced {
  final FirebaseAuthRepositoryNew _repository;

  SignUpWithEmailAndPasswordUseCaseEnhanced({
    required FirebaseAuthRepositoryNew repository,
  }) : _repository = repository;

  Future<Either<Failure, UserCredential>> call({
    required AuthEntityEnhanced authEntity,
  }) async {
    if (!authEntity.isValid) {
      return Left(Failure(message: authEntity.validationError!));
    }

    if (authEntity.password.strength == PasswordStrength.weak) {
      return Left(Failure(message: 'Password is too weak. Please use a stronger password.'));
    }

    return await _repository.signUpWithEmailAndPassword(
      authEntity: AuthEntity(
        email: authEntity.email.value,
        password: authEntity.password.value,
      ),
    );
  }
}