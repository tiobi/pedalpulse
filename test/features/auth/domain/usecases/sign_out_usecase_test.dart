// ignore_for_file: prefer_const_constructors

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_out_usecase.dart';

import '../../../../mocks/mock_firebase_auth_repository.mocks.dart';

void main() {
  late SignOutUseCase useCase;
  late MockFirebaseAuthRepository repository;

  setUp(() {
    repository = MockFirebaseAuthRepository();
    useCase = SignOutUseCase(repository: repository);
  });

  group('SignOutUseCase Text', () {
    test('should sign out the user successfully', () async {
      // Arrange
      when(repository.signOut()).thenAnswer((_) async => Right(unit));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(unit));
      verify(repository.signOut());
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when the sign out fails', () async {
      // Arrange
      final Failure failure = FirebaseAuthFailure(
        message: 'Server Failure',
      );
      when(repository.signOut()).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left(failure));
      verify(repository.signOut());
      verifyNoMoreInteractions(repository);
    });
  });

  // test('should sign out the user successfully', () async {
  //   // Arrange
  //   when(mockFirebaseAuthRepository.signOut())
  //       .thenAnswer((_) async => Right(unit));

  //   // Act
  //   final result = await usecase();

  //   // Assert
  //   expect(result, Right(unit));
  //   verify(mockFirebaseAuthRepository.signOut());
  //   verifyNoMoreInteractions(mockFirebaseAuthRepository);
  // });

  // test('should return a Failure when the sign out fails', () async {
  //   // Arrange
  //   final Failure failure = AuthFailure(
  //     'Server Failure',
  //   ); // Assuming ServerFailure is a class that extends Failure
  //   when(mockFirebaseAuthRepository.signOut())
  //       .thenAnswer((_) async => Left(failure));

  //   // Act
  //   final result = await usecase();

  //   // Assert
  //   expect(result, Left(failure));
  //   verify(mockFirebaseAuthRepository.signOut());
  //   verifyNoMoreInteractions(mockFirebaseAuthRepository);
  // });
}
