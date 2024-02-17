import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedalpulse/core/errors/google_auth_failure.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource.dart';

import '../../../../core/errors/apple_auth_failure.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/social_auth_repository.dart';

class SocialAuthRepositoryImpl implements SocialAuthRepository {
  final SocialAuthDataSource dataSource;

  SocialAuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    try {
      final UserCredential userCredential = await dataSource.signInWithGoogle();
      return Right(userCredential);
    } catch (e) {
      return Left(GoogleAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithApple() async {
    try {
      final UserCredential userCredential = await dataSource.signInWithApple();
      return Right(userCredential);
    } catch (e) {
      return Left(AppleAuthFailure(message: e.toString()));
    }
  }
}
