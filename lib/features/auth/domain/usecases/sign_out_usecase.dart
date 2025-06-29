import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/firebase_auth_repository.dart';

class SignOutUseCase {
  final FirebaseAuthRepository repository;

  SignOutUseCase({
    required this.repository,
  });

  Future<Either<Failure, Unit>> call() async {
    return await repository.signOut();
  }
}
