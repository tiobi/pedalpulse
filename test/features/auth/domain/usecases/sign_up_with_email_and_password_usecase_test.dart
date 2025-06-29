import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';

import '../../../../mocks/auth/firebase/mock_firebase_auth_repository.mocks.dart';
import '../../../../mocks/auth/user_credential/mock_user_credential.mocks.dart';

void main() {
  late SignUpWithEmailAndPasswordUseCase useCase;
  late MockFirebaseAuthRepository repository;

  setUp(() {
    repository = MockFirebaseAuthRepository();
    useCase = SignUpWithEmailAndPasswordUseCase(repository: repository);
  });

  const String validEmail = 'test@example.com';
  const String validPassword = 'password123';
  const String invalidEmail = 'invalid-email';
  const String shortPassword = '12345';
  const String emptyEmail = '';
  const String emptyPassword = '';

  final UserCredential userCredential = MockUserCredential();

  group('SignUpWithEmailAndPasswordUseCase', () {
    group('Input validation', () {
      test('should return failure for invalid email', () async {
        final result = await useCase(
          email: invalidEmail,
          password: validPassword,
        );

        expect(result.isLeft(), true);
        expect(
          result.fold((failure) => failure, (r) => r),
          isA<FirebaseAuthFailure>(),
        );
        verifyNever(repository.signUpWithEmailAndPassword(authEntity: any));
      });

      test('should return failure for password too short', () async {
        final result = await useCase(
          email: validEmail,
          password: shortPassword,
        );

        expect(result.isLeft(), true);
        expect(
          result.fold((failure) => failure, (r) => r),
          isA<FirebaseAuthFailure>(),
        );
        verifyNever(repository.signUpWithEmailAndPassword(authEntity: any));
      });

      test('should return failure for empty email', () async {
        final result = await useCase(
          email: emptyEmail,
          password: validPassword,
        );

        expect(result.isLeft(), true);
        expect(
          result.fold((failure) => failure, (r) => r),
          isA<FirebaseAuthFailure>(),
        );
        verifyNever(repository.signUpWithEmailAndPassword(authEntity: any));
      });

      test('should return failure for empty password', () async {
        final result = await useCase(
          email: validEmail,
          password: emptyPassword,
        );

        expect(result.isLeft(), true);
        expect(
          result.fold((failure) => failure, (r) => r),
          isA<FirebaseAuthFailure>(),
        );
        verifyNever(repository.signUpWithEmailAndPassword(authEntity: any));
      });

      test('should return specific error message for invalid email', () async {
        final result = await useCase(
          email: invalidEmail,
          password: validPassword,
        );

        final failure = result.fold((failure) => failure, (r) => null);
        expect(failure, isA<FirebaseAuthFailure>());
        expect((failure as FirebaseAuthFailure).message,
            'Please enter a valid email address');
      });

      test('should return specific error message for short password', () async {
        final result = await useCase(
          email: validEmail,
          password: shortPassword,
        );

        final failure = result.fold((failure) => failure, (r) => null);
        expect(failure, isA<FirebaseAuthFailure>());
        expect((failure as FirebaseAuthFailure).message,
            'Password must be at least 6 characters long');
      });
    });

    group('Valid input processing', () {
      test('should sign up user with valid email and password', () async {
        final expectedAuthEntity = AuthEntity(
          email: validEmail,
          password: validPassword,
          authType: const AuthType.emailPassword(),
        );

        when(repository.signUpWithEmailAndPassword(authEntity: expectedAuthEntity))
            .thenAnswer((_) async => Right(userCredential));

        final result = await useCase(
          email: validEmail,
          password: validPassword,
        );

        expect(result, Right(userCredential));
        verify(repository.signUpWithEmailAndPassword(authEntity: expectedAuthEntity))
            .called(1);
        verifyNoMoreInteractions(repository);
      });

      test('should handle repository failures gracefully', () async {
        final repositoryFailure = FirebaseAuthFailure(message: 'Network error');
        final expectedAuthEntity = AuthEntity(
          email: validEmail,
          password: validPassword,
          authType: const AuthType.emailPassword(),
        );

        when(repository.signUpWithEmailAndPassword(authEntity: expectedAuthEntity))
            .thenAnswer((_) async => Left(repositoryFailure));

        final result = await useCase(
          email: validEmail,
          password: validPassword,
        );

        expect(result, Left(repositoryFailure));
        verify(repository.signUpWithEmailAndPassword(authEntity: expectedAuthEntity))
            .called(1);
      });
    });

    group('Edge cases', () {
      test('should handle complex valid email formats', () async {
        const complexEmails = [
          'user.name+tag@example.co.uk',
          'test123@domain-name.org',
          'user_name@test.museum',
        ];

        for (final email in complexEmails) {
          final expectedAuthEntity = AuthEntity(
            email: email,
            password: validPassword,
            authType: const AuthType.emailPassword(),
          );

          when(repository.signUpWithEmailAndPassword(authEntity: expectedAuthEntity))
              .thenAnswer((_) async => Right(userCredential));

          final result = await useCase(
            email: email,
            password: validPassword,
          );

          expect(result, Right(userCredential));
        }
      });

      test('should handle minimum valid password length', () async {
        const minPassword = '123456';
        final expectedAuthEntity = AuthEntity(
          email: validEmail,
          password: minPassword,
          authType: const AuthType.emailPassword(),
        );

        when(repository.signUpWithEmailAndPassword(authEntity: expectedAuthEntity))
            .thenAnswer((_) async => Right(userCredential));

        final result = await useCase(
          email: validEmail,
          password: minPassword,
        );

        expect(result, Right(userCredential));
      });
    });
  });
}
