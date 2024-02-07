// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_out_usecase.dart';
import '../../helpers/auth_test_helpers.dart';

void main() {
  late MockFirebaseAuthRepository mockFirebaseAuthRepository;
  late SignOutUseCase usecase;

  setUp(() {
    mockFirebaseAuthRepository = MockFirebaseAuthRepository();
    usecase = SignOutUseCase(repository: mockFirebaseAuthRepository);
  });

  test('should sign out from the repository', () async {
    // arrange
    when(mockFirebaseAuthRepository.signOut())
        .thenAnswer((_) async => right(unit));
    // act
    final result = await usecase();
    // assert
    expect(result, equals(Right(unit)));
    verify(() => mockFirebaseAuthRepository.signOut()).called(1);
    verifyNoMoreInteractions(mockFirebaseAuthRepository);
  });
}
