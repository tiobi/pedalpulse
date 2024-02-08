import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';

import '../../mocks/mock_firebase_auth_repository.mocks.dart';
import '../../mocks/mock_user_credential.mocks.dart';

void main() {
  late SignInWithEmailAndPasswordUseCase useCase;
  late MockFirebaseAuthRepository repository;

  setUp(() {
    repository = MockFirebaseAuthRepository();
    useCase = SignInWithEmailAndPasswordUseCase(repository: repository);
  });

  const String tEmail = 'hello@world.com';
  const String tPassword = 'password1234';
  const String tEmptyEmail = '';
  const String tEmptyPassword = '';

  const AuthEntity tAuthEntity = AuthEntity(
    email: tEmail,
    password: tPassword,
  );
  const AuthEntity tEmptyAuthEntity = AuthEntity(
    email: tEmptyEmail,
    password: tEmptyPassword,
  );
  final UserCredential tUserCredential = MockUserCredential();

  final Failure failure = FirebaseAuthFailure(
    'Email and password cannot be empty',
  );

  group('SignInWithEmailAndPasswordUseCase Text', () {
    test('should sign in the user and get user credential', () async {
      // Arrange
      when(repository.signInWithEmailAndPassword(
        authEntity: tAuthEntity,
      )).thenAnswer((_) async => Right(tUserCredential));

      // Act
      final result = await useCase.call(authEntity: tAuthEntity);

      // Assert
      expect(result, Right(tUserCredential));
      verify(repository.signInWithEmailAndPassword(
        authEntity: tAuthEntity,
      )).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when empty email and password is provided',
        () async {
      // Arrange

      when(repository.signInWithEmailAndPassword(
        authEntity: tEmptyAuthEntity,
      )).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase.call(
        authEntity: tEmptyAuthEntity,
      );

      // Assert
      expect(result, Left(failure));
      verify(repository.signInWithEmailAndPassword(
        authEntity: tEmptyAuthEntity,
      )).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a failure when the sign in fails', () async {
      // Arrange
      final Failure failure = FirebaseAuthFailure(
        'Server Failure',
      );
      when(repository.signInWithEmailAndPassword(
        authEntity: tAuthEntity,
      )).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase.call(
        authEntity: tAuthEntity,
      );

      // Assert
      expect(result, Left(failure));
      verify(repository.signInWithEmailAndPassword(
        authEntity: tAuthEntity,
      )).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
