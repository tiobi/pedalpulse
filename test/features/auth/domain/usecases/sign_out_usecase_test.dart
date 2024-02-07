import 'package:dartz/dartz.dart';
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

  test('should sign out the user and return unit', () async {
    when(mockFirebaseAuthRepository.signOut())
        .thenAnswer((_) async => Future.value(const Right(unit)));

    final result = await signOutUseCase.call();

    verify(mockFirebaseAuthRepository.signOut()).called(1);
    expect(result, const Right(unit));
  });
}
