import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';

abstract class FirebaseAuthRepository {
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  });

  Future<Either<Failure, UserCredential>> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  });

  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, bool>> isEmailVerified({
    required String email,
  });
}
