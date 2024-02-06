import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_out_usecase.dart';

import '../../helpers/auth_test_helpers.dart';

void main() {
  late final SignOutUseCase signOutUseCase;
  late final MockFirebaseAuthRepository mockFirebaseAuthRepository;

  setUp(() {
    mockFirebaseAuthRepository = MockFirebaseAuthRepository();
    signOutUseCase = SignOutUseCase(repository: mockFirebaseAuthRepository);
  });

  test('should call signOut from FirebaseAuthRepository', () async {
    await signOutUseCase();
    verify(mockFirebaseAuthRepository.signOut());
  });
}
