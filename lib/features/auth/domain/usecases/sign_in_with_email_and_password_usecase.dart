import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/firebase_auth_failure.dart';
import '../entities/auth_entity.dart';
import '../repositories/firebase_auth_repository.dart';

class SignInWithEmailAndPasswordUseCase {
  final FirebaseAuthRepository repository;

  SignInWithEmailAndPasswordUseCase({
    required this.repository,
  });

  Future<Either<Failure, UserCredential>> call({
    required String email,
    required String password,
  }) async {
    final authEntity = AuthEntity(
      email: email,
      password: password,
      authType: const AuthType.emailPassword(),
    );

    if (!authEntity.isValid) {
      return Left(FirebaseAuthFailure(
        message: _getValidationErrorMessage(authEntity),
      ));
    }

    return await repository.signInWithEmailAndPassword(
      authEntity: authEntity,
    );
  }

  String _getValidationErrorMessage(AuthEntity authEntity) {
    if (!authEntity.isEmailValid) {
      return 'Please enter a valid email address';
    }
    if (!authEntity.isPasswordValid) {
      return 'Password must be at least 6 characters long';
    }
    return 'Invalid input';
  }
}
