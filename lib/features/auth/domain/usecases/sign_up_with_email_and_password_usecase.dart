import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/auth_entity.dart';
import '../repositories/firebase_auth_repository.dart';

class SignUpWithEmailAndPasswordUseCase {
  final FirebaseAuthRepository repository;

  SignUpWithEmailAndPasswordUseCase({
    required this.repository,
  });

  Future<Either<Failure, Unit>> call({
    required AuthEntity authEntity,
  }) async {
    return await repository.signUpWithEmailAndPassword(
      authEntity: authEntity,
    );
  }
}
