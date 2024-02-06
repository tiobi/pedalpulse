import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';

import '../../../../core/errors/failure.dart';

class SignOutUseCase {
  final FirebaseAuthRepository repository;

  SignOutUseCase({
    required this.repository,
  });

  Future<Either<Failure, Unit>> call() async => await repository.signOut();
}
