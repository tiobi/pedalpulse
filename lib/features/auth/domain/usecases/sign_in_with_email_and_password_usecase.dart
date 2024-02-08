import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
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
    return await repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
