import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/usecases/is_email_verified_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/usecases/sign_in_with_email_and_password_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_and_password_usecase.dart';
import '../../domain/entities/auth_entity.dart';

class AuthProvider extends ChangeNotifier {
  IsEmailVerifiedUseCase isEmailVerifiedUseCase;
  SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  SignOutUseCase signOutUseCase;
  SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase;

  AuthProvider({
    required this.isEmailVerifiedUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.signInWithEmailAndPasswordUseCase,
    required this.signOutUseCase,
    required this.signUpWithEmailAndPasswordUseCase,
  });

  Future<void> isEmailVerified({
    required String email,
  }) async {
    final result = await isEmailVerifiedUseCase(email: email);

    if (result.isRight()) {}
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await sendPasswordResetEmailUseCase(email: email);
  }

  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try {
      final Either<Failure, UserCredential> result =
          await signInWithEmailAndPasswordUseCase(authEntity: authEntity);

      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseAuthFailure.userNotFoundCode) {
        return Left(FirebaseAuthFailure(
            message: FirebaseAuthFailure.userNotFoundMessage));
      } else if (e.code == FirebaseAuthFailure.wrongPasswordCode) {
        return Left(FirebaseAuthFailure(
          message: FirebaseAuthFailure.wrongPasswordMessage,
        ));
      } else {
        return Left(
          FirebaseAuthFailure(message: e.message.toString()),
        );
      }
    }
  }

  Future<void> signOut() async {}

  Future<void> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    await signUpWithEmailAndPasswordUseCase(authEntity: authEntity);
  }
}
