import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/google_auth_failure.dart';
import '../entities/auth_entity.dart';
import '../repositories/social_auth_repository.dart';

class SignInWithGoogleUseCase {
  final SocialAuthRepository repository;

  SignInWithGoogleUseCase({
    required this.repository,
  });

  Future<Either<Failure, UserCredential>> call() async {
    try {
      return await repository.signInWithGoogle();
    } catch (e) {
      return Left(GoogleAuthFailure(
        message: 'Failed to sign in with Google: ${e.toString()}',
      ));
    }
  }

  AuthEntity createGoogleAuthEntity({
    required String email,
    Map<String, dynamic>? googleData,
  }) {
    return AuthEntity(
      email: email,
      authType: const AuthType.google(),
      socialData: googleData,
    );
  }
}
