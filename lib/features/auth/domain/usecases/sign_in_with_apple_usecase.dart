import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/apple_auth_failure.dart';
import '../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';
import '../repositories/social_auth_repository.dart';

class SignInWithAppleUseCase {
  final SocialAuthRepository repository;

  SignInWithAppleUseCase({
    required this.repository,
  });

  Future<Either<Failure, UserCredential>> call() async {
    try {
      return await repository.signInWithApple();
    } catch (e) {
      return Left(AppleAuthFailure(
        message: 'Failed to sign in with Apple: ${e.toString()}',
      ));
    }
  }

  AuthEntity createAppleAuthEntity({
    required String email,
    Map<String, dynamic>? appleData,
  }) {
    return AuthEntity(
      email: email,
      authType: const AuthType.apple(),
      socialData: appleData,
    );
  }
}
