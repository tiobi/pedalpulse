import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';

import '../../../../core/errors/failure.dart';

class IsEmailVerifiedUseCase {
  final FirebaseAuthRepository repository;

  IsEmailVerifiedUseCase({
    required this.repository,
  });

  Future<Either<Failure, bool>> call(String email) async {
    return repository.isEmailVerified(email: email);
  }
}
