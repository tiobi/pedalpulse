// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_out_usecase.dart';

import '../../helpers/firebase_auth_repository_helper.mocks.dart';

void main() {
  late SignOutUseCase usecase;
  late MockFirebaseAuthRepository mockFirebaseAuthRepository;

  setUp(() {
    mockFirebaseAuthRepository = MockFirebaseAuthRepository();
    usecase = SignOutUseCase(repository: mockFirebaseAuthRepository);
  });

  test('should sign out the user successfully', () async {
    // Arrange
    when(mockFirebaseAuthRepository.signOut())
        .thenAnswer((_) async => Right(unit));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(unit));
    verify(mockFirebaseAuthRepository.signOut());
    verifyNoMoreInteractions(mockFirebaseAuthRepository);
  });

  test('should return a Failure when the sign out fails', () async {
    // Arrange
    final Failure failure = AuthFailure(
      'Server Failure',
    ); // Assuming ServerFailure is a class that extends Failure
    when(mockFirebaseAuthRepository.signOut())
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(mockFirebaseAuthRepository.signOut());
    verifyNoMoreInteractions(mockFirebaseAuthRepository);
  });
}
