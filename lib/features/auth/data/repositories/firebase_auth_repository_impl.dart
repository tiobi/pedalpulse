import 'package:dartz/dartz.dart';
import 'package:pedalpulse/core/entities/user_entity.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/data/datasources/firebase_auth_datasource.dart';

import '../../domain/repositories/firebase_auth_repository.dart';

class FirebaseAuthRepositoryImpl implements FirebaseAuthRepository {
  final FirebaseAuthDataSource dataSource;

  FirebaseAuthRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await dataSource.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailVerified({required String email}) {
    // TODO: implement isEmailVerified
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await dataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required String confirmPassword}) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }
}
