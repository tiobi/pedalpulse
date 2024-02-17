import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedalpulse/features/auth/domain/repositories/social_auth_repository.dart';

import '../../../../core/errors/failure.dart';

class SignInWithGoogleUseCase {
  final SocialAuthRepository repository;

  SignInWithGoogleUseCase({required this.repository});

  Future<Either<Failure, UserCredential>> call() async {
    return await repository.signInWithGoogle();
  }
}
