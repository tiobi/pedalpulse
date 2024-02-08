import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';
import '../repositories/firebase_auth_repository.dart';

class SignInWithEmailAndPasswordUseCase {
  final FirebaseAuthRepository repository;

  SignInWithEmailAndPasswordUseCase({
    required this.repository,
  });

  Future<Either<Failure, UserCredential>> call({
    required AuthEntity authEntity,
  }) async {
    return await repository.signInWithEmailAndPassword(
      authEntity: authEntity,
    );
  }
}
