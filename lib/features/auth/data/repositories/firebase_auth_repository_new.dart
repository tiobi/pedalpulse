import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/firebase_auth_failure.dart';
import '../datasources/firebase_auth_datasource_new.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/firebase_auth_repository.dart';

class FirebaseAuthRepositoryNew implements FirebaseAuthRepository {
  final FirebaseAuthDataSourceNew _dataSource;

  FirebaseAuthRepositoryNew({
    required FirebaseAuthDataSourceNew dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _dataSource.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(FirebaseAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailVerified({
    required String email,
  }) async {
    try {
      final bool isEmailVerified = await _dataSource.isEmailVerified();
      return Right(isEmailVerified);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(FirebaseAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try {
      final UserCredential userCredential = await _dataSource
          .signInWithEmailAndPassword(authEntity: authEntity);

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(FirebaseAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(FirebaseAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try {
      final UserCredential userCredential = await _dataSource
          .signUpWithEmailAndPassword(authEntity: authEntity);

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(FirebaseAuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentUserUid() async {
    try {
      final String uid = await _dataSource.getCurrentUserUid();
      return Right(uid);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(FirebaseAuthFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Unit>> sendEmailVerification() async {
    try {
      await _dataSource.sendEmailVerification();
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(FirebaseAuthFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Unit>> initializeUserData({
    required String uid,
    required String email,
  }) async {
    try {
      await _dataSource.initializeUserData(uid: uid, email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(FirebaseAuthFailure(message: e.toString()));
    }
  }

  Stream<User?> get authStateChanges => _dataSource.authStateChanges;
}