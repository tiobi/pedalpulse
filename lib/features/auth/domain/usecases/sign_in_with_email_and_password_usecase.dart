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
    /// Check if email is verified.
    /// If verified, perform sign in.
    /// Else, return failure with messages.
    ///
    ///

    // final boolOrFailure =
    //     await repository.isEmailVerified(email: authEntity.email);

    // bool isVerified = false;

    // boolOrFailure.fold((failure) {
    //   return Left(failure);
    // }, (bool) {
    //   isVerified = bool;
    // });

    // if (!isVerified) {
    //   return Left(AuthFailure(message: 'Email is not verified.'));
    // }

    return await repository.signInWithEmailAndPassword(
      authEntity: authEntity,
    );
  }
}
