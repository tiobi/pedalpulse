import '../repositories/firebase_auth_repository.dart';

class FirebaseAuthUseCase {
  final FirebaseAuthRepository repository;

  FirebaseAuthUseCase({
    required this.repository,
  });
}
