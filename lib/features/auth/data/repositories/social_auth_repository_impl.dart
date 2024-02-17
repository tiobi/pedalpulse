import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/repositories/social_auth_repository.dart';

class SocialAuthRepositoryImpl implements SocialAuthRepository {
  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithApple() async {
    throw UnimplementedError();
  }
}
