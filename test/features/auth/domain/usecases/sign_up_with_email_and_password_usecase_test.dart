import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';

import '../../mocks/mock_firebase_auth_repository.mocks.dart';

void main() {
  late SignUpWithEmailAndPasswordUseCase useCase;
  late MockFirebaseAuthRepository repository;

  setUp(() {
    repository = MockFirebaseAuthRepository();
    useCase = SignUpWithEmailAndPasswordUseCase(repository: repository);
  });
}
