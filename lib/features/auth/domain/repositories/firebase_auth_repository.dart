import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';

abstract class FirebaseAuthRepository {
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, bool>> isEmailVerified({
    required String email,
  });
}
