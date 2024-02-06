import 'package:dartz/dartz.dart';

import '../../../../core/entities/user_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/firebase_auth_repository.dart';

class SignInWithEmailAndPasswordUseCase {
  final FirebaseAuthRepository repository;

  SignInWithEmailAndPasswordUseCase({
    required this.repository,
  });

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
