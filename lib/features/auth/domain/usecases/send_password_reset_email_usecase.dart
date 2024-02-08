import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/firebase_auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final FirebaseAuthRepository repository;

  SendPasswordResetEmailUseCase({
    required this.repository,
  });

  Future<Either<Failure, void>> call(String email) async {
    return repository.sendPasswordResetEmail(email: email);
  }
}
