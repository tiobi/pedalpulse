import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';

import '../../../../mocks/auth/firebase/mock_firebase_auth_datasource.mocks.dart';
import '../../../../mocks/auth/user_credential/mock_user_credential.mocks.dart';

void main() {
  late FirebaseAuthRepository repository;
  late MockFirebaseAuthDataSource dataSource;

  setUp(() {
    dataSource = MockFirebaseAuthDataSource();
    repository = FirebaseAuthRepositoryImpl(dataSource: dataSource);
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

  group('FirebaseAuthRepositoryImpl Test', () {
    /// Sign Up With Email And Password Test
    ///
    group('SignInWithEmailAndPassword Test', () {
      test('should sign in the user and get user credential', () async {
        // Arrange
        when(dataSource.signInWithEmailAndPassword(authEntity: tAuthEntity))
            .thenAnswer((_) async => tUserCredential);

        // Act
        final result = await repository.signInWithEmailAndPassword(
            authEntity: tAuthEntity);

        // Assert
        expect(result, Right(tUserCredential));
        verify(dataSource.signInWithEmailAndPassword(authEntity: tAuthEntity))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the sign in fails', () async {
        // Arrange
        when(dataSource.signInWithEmailAndPassword(authEntity: tAuthEntity))
            .thenThrow(FirebaseAuthFailure(message: 'Server Failure'));

        // Act
        final result = await repository.signInWithEmailAndPassword(
            authEntity: tAuthEntity);

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((failure) => failure, (r) => r),
            isA<FirebaseAuthFailure>());
      });

      test('should return a Failure when the email and password are empty',
          () async {
        // Arrange
        when(dataSource.signInWithEmailAndPassword(
                authEntity: tEmptyAuthEntity))
            .thenThrow(FirebaseAuthFailure(message: 'Server Failure'));

        // Act
        final result = await repository.signInWithEmailAndPassword(
            authEntity: tEmptyAuthEntity);

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((failure) => failure, (r) => r),
            isA<FirebaseAuthFailure>());
      });
    });

    /// Sign Up With Email And Password Test
    ///
    group('SignUpWithEmailAndPassword Test', () {
      test('should sign up the user and get user credential', () async {
        // Arrange
        when(dataSource.signUpWithEmailAndPassword(authEntity: tAuthEntity))
            .thenAnswer((_) async => tUserCredential);

        // Act
        final result = await repository.signUpWithEmailAndPassword(
            authEntity: tAuthEntity);

        // Assert
        expect(result, Right(tUserCredential));
        verify(dataSource.signUpWithEmailAndPassword(authEntity: tAuthEntity))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the sign up fails', () async {
        // Arrange
        when(dataSource.signUpWithEmailAndPassword(authEntity: tAuthEntity))
            .thenThrow(FirebaseAuthFailure(message: 'Server Failure'));

        // Act
        final result = await repository.signUpWithEmailAndPassword(
            authEntity: tAuthEntity);

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((failure) => failure, (r) => r),
            isA<FirebaseAuthFailure>());
      });
    });

    /// Send Password Reset Email Test
    ///
    group('sendPasswordResetEmail Test', () {
      test('should send a password reset email', () async {
        // Arrange
        when(dataSource.sendPasswordResetEmail(email: tEmail))
            .thenAnswer((_) async => unit);

        // Act
        final result = await repository.sendPasswordResetEmail(email: tEmail);

        // Assert
        expect(result, const Right(unit));
        verify(dataSource.sendPasswordResetEmail(email: tEmail)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the password reset email fails',
          () async {
        // Arrange
        when(dataSource.sendPasswordResetEmail(email: tEmail))
            .thenThrow(FirebaseAuthFailure(message: 'Server Failure'));

        // Act
        final result = await repository.sendPasswordResetEmail(email: tEmail);

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((failure) => failure, (r) => r),
            isA<FirebaseAuthFailure>());
      });
    });

    /// Sign Out Test
    ///
    group('signOut Test', () {
      test('should sign out the user', () async {
        // Arrange
        when(dataSource.signOut()).thenAnswer((_) async => unit);

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result, const Right(unit));
        verify(dataSource.signOut()).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the sign out fails', () async {
        // Arrange
        when(dataSource.signOut())
            .thenThrow(FirebaseAuthException(code: 'error'));

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((failure) => failure, (r) => r),
            isA<FirebaseAuthFailure>());
      });
    });

    /// Is Email Verified Test
    ///
    group('isEmailVerified Test', () {
      test('should return true if the email is verified', () async {
        // Arrange
        when(dataSource.isEmailVerified(email: tEmail))
            .thenAnswer((_) async => true);

        // Act
        final result = await repository.isEmailVerified(email: tEmail);

        // Assert
        expect(result, const Right(true));
        verify(dataSource.isEmailVerified(email: tEmail)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return false if the email is not verified', () async {
        // Arrange
        when(dataSource.isEmailVerified(email: tEmail))
            .thenAnswer((_) async => false);

        // Act
        final result = await repository.isEmailVerified(email: tEmail);

        // Assert
        expect(result, const Right(false));
        verify(dataSource.isEmailVerified(email: tEmail)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the email verification fails',
          () async {
        // Arrange
        when(dataSource.isEmailVerified(email: tEmail))
            .thenThrow(FirebaseAuthFailure(message: 'Server Failure'));

        // Act
        final result = await repository.isEmailVerified(email: tEmail);

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((failure) => failure, (r) => r),
            isA<FirebaseAuthFailure>());
      });
    });
  });
}
