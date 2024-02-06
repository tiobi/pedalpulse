import 'package:dartz/dartz.dart';
import 'package:pedalpulse/core/entities/user_entity.dart';

import '../../domain/entities/auth_entity.dart';

abstract class FirebaseAuthDataSource {
  Future<Unit> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  });

  Future<UserEntity> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  });

  Future<Unit> sendEmailVerification({
    required String email,
  });

  Future<Unit> initializeUserData({
    required String uid,
    required String email,
  });

  Future<Unit> sendPasswordResetEmail({
    required String email,
  });

  Future<Unit> signOut();

  Future<bool> isEmailVerified({
    required String email,
  });
}
