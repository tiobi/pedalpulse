import 'package:pedalpulse/core/entities/user_entity.dart';

import '../../domain/entities/auth_entity.dart';

abstract class FirebaseAuthDataSource {
  Future<void> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  });

  Future<UserEntity> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signOut();

  Future<bool> isEmailVerified({
    required String email,
  });
}
