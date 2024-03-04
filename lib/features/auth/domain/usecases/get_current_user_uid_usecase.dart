import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/firebase_auth_repository.dart';

class GetCurrentUserUidUseCase {
  final FirebaseAuthRepository repository;

  GetCurrentUserUidUseCase({
    required this.repository,
  });

  Future<Either<Failure, String>> call() async {
    return repository.getCurrentUserUid();
  }
}
