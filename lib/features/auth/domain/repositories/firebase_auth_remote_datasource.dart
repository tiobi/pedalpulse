import 'package:dartz/dartz.dart';

import '../../../../core/entities/user_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class FirebaseAuthRemoteDataSource {
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, void>> signOut();
}
