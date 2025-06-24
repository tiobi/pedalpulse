import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_up_with_email_and_password_usecase_enhanced.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository_new.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity_enhanced.dart';
import 'package:pedalpulse/features/auth/domain/value_objects/email.dart';
import 'package:pedalpulse/features/auth/domain/value_objects/password.dart';
import 'package:pedalpulse/core/errors/auth_failure.dart';

@GenerateMocks([FirebaseAuthRepositoryNew])
import 'sign_up_with_email_and_password_usecase_enhanced_test.mocks.dart';

void main() {
  group('SignUpWithEmailAndPasswordUseCaseEnhanced', () {
    late SignUpWithEmailAndPasswordUseCaseEnhanced useCase;
    late MockFirebaseAuthRepositoryNew mockRepository;

    setUp(() {
      mockRepository = MockFirebaseAuthRepositoryNew();
      useCase = SignUpWithEmailAndPasswordUseCaseEnhanced(repository: mockRepository);
    });

    group('Valid Sign Up', () {
      test('should sign up successfully with strong password', () async {
        final email = Email('test@example.com');
        final strongPassword = Password('StrongPass123!');
        final authEntity = AuthEntityEnhanced(email: email, password: strongPassword);
        
        when(mockRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (uid) => expect(uid, 'user123'),
        );

        verify(mockRepository.signUpWithEmailAndPassword(
          'test@example.com',
          'StrongPass123!',
        )).called(1);
      });

      test('should sign up successfully with medium strength password', () async {
        final email = Email('test@example.com');
        final mediumPassword = Password('Password123');
        final authEntity = AuthEntityEnhanced(email: email, password: mediumPassword);
        
        when(mockRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        verify(mockRepository.signUpWithEmailAndPassword(
          'test@example.com',
          'Password123',
        )).called(1);
      });
    });

    group('Password Strength Validation', () {
      test('should reject weak passwords for sign up', () async {
        final email = Email('test@example.com');
        final weakPassword = Password('password');
        final authEntity = AuthEntityEnhanced(email: email, password: weakPassword);

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Password is too weak'));
            expect(failure.message, contains('Please use a stronger password'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signUpWithEmailAndPassword(any, any));
      });

      test('should reject another weak password pattern', () async {
        final email = Email('test@example.com');
        final weakPassword = Password('123456');
        final authEntity = AuthEntityEnhanced(email: email, password: weakPassword);

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Password is too weak'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signUpWithEmailAndPassword(any, any));
      });

      test('should accept minimum medium strength password', () async {
        final email = Email('test@example.com');
        final mediumPassword = Password('Password1');
        final authEntity = AuthEntityEnhanced(email: email, password: mediumPassword);
        
        when(mockRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        expect(authEntity.password.strength, PasswordStrength.medium);
      });
    });

    group('Domain Validation', () {
      test('should fail for invalid email format', () async {
        final invalidEmail = Email('invalid-email');
        final strongPassword = Password('StrongPass123!');
        final authEntity = AuthEntityEnhanced(email: invalidEmail, password: strongPassword);

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Please enter a valid email address'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signUpWithEmailAndPassword(any, any));
      });

      test('should fail for invalid password length', () async {
        final validEmail = Email('test@example.com');
        final invalidPassword = Password('123');
        final authEntity = AuthEntityEnhanced(email: validEmail, password: invalidPassword);

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Password must be at least 6 characters long'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signUpWithEmailAndPassword(any, any));
      });

      test('should fail for both invalid email and weak password', () async {
        final invalidEmail = Email('invalid');
        final weakPassword = Password('weak');
        final authEntity = AuthEntityEnhanced(email: invalidEmail, password: weakPassword);

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Please enter a valid email address'));
            expect(failure.message, contains('Password must be at least 6 characters long'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signUpWithEmailAndPassword(any, any));
      });

      test('should prioritize basic validation over strength validation', () async {
        final validEmail = Email('test@example.com');
        final invalidPassword = Password('123');
        final authEntity = AuthEntityEnhanced(email: validEmail, password: invalidPassword);

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure.message, contains('Password must be at least 6 characters long'));
            expect(failure.message, isNot(contains('Password is too weak')));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );
      });
    });

    group('Repository Failures', () {
      test('should handle email already in use error', () async {
        final email = Email('existing@example.com');
        final strongPassword = Password('StrongPass123!');
        final authEntity = AuthEntityEnhanced(email: email, password: strongPassword);
        
        when(mockRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Left(AuthFailure('Email already in use')));

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) => expect(failure.message, 'Email already in use'),
          (uid) => fail('Expected failure but got success: $uid'),
        );
      });

      test('should handle network errors', () async {
        final email = Email('test@example.com');
        final strongPassword = Password('StrongPass123!');
        final authEntity = AuthEntityEnhanced(email: email, password: strongPassword);
        
        when(mockRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Left(AuthFailure('Network error')));

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) => expect(failure.message, 'Network error'),
          (uid) => fail('Expected failure but got success: $uid'),
        );
      });

      test('should handle invalid email domain errors', () async {
        final email = Email('test@invalid-domain.com');
        final strongPassword = Password('StrongPass123!');
        final authEntity = AuthEntityEnhanced(email: email, password: strongPassword);
        
        when(mockRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Left(AuthFailure('Invalid email domain')));

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) => expect(failure.message, 'Invalid email domain'),
          (uid) => fail('Expected failure but got success: $uid'),
        );
      });
    });

    group('Password Strength Scenarios', () {
      test('should test various weak password patterns', () async {
        final email = Email('test@example.com');
        final weakPatterns = [
          'password',
          '123456',
          'qwerty',
          'abc123',
          'simple',
        ];

        for (final passwordStr in weakPatterns) {
          final weakPassword = Password(passwordStr);
          final authEntity = AuthEntityEnhanced(email: email, password: weakPassword);

          final result = await useCase(SignUpParams(authEntity));

          expect(result, isA<Left<AuthFailure, String>>(), 
                 reason: '$passwordStr should be rejected as weak');
          expect(authEntity.password.strength, PasswordStrength.weak);
        }

        verifyNever(mockRepository.signUpWithEmailAndPassword(any, any));
      });

      test('should accept various medium strength passwords', () async {
        final email = Email('test@example.com');
        final mediumPatterns = [
          'Password1',
          'MyPass123',
          'Valid1234',
          'Test12345',
        ];

        for (final passwordStr in mediumPatterns) {
          final mediumPassword = Password(passwordStr);
          final authEntity = AuthEntityEnhanced(email: email, password: mediumPassword);
          
          when(mockRepository.signUpWithEmailAndPassword(any, any))
              .thenAnswer((_) async => Right('user123'));

          final result = await useCase(SignUpParams(authEntity));

          expect(result, isA<Right<AuthFailure, String>>(), 
                 reason: '$passwordStr should be accepted as medium strength');
          expect(authEntity.password.strength, PasswordStrength.medium);
        }
      });

      test('should accept various strong passwords', () async {
        final email = Email('test@example.com');
        final strongPatterns = [
          'StrongPass123!',
          'Complex@Password2023',
          'MySecure#Pass123',
          'Valid!@#Password123',
        ];

        for (final passwordStr in strongPatterns) {
          final strongPassword = Password(passwordStr);
          final authEntity = AuthEntityEnhanced(email: email, password: strongPassword);
          
          when(mockRepository.signUpWithEmailAndPassword(any, any))
              .thenAnswer((_) async => Right('user123'));

          final result = await useCase(SignUpParams(authEntity));

          expect(result, isA<Right<AuthFailure, String>>(), 
                 reason: '$passwordStr should be accepted as strong');
          expect(authEntity.password.strength, PasswordStrength.strong);
        }
      });
    });

    group('Edge Cases', () {
      test('should handle long valid credentials', () async {
        final email = Email('verylongemailaddress@verylongdomainname.com');
        final longStrongPassword = Password('VeryLongButStrongPassword123!@#');
        final authEntity = AuthEntityEnhanced(email: email, password: longStrongPassword);
        
        when(mockRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        verify(mockRepository.signUpWithEmailAndPassword(
          'verylongemailaddress@verylongdomainname.com',
          'VeryLongButStrongPassword123!@#',
        )).called(1);
      });

      test('should handle special characters in credentials', () async {
        final email = Email('user+special@domain.com');
        final specialPassword = Password('Special!@#\$%^&*()Password123');
        final authEntity = AuthEntityEnhanced(email: email, password: specialPassword);
        
        when(mockRepository.signUpWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignUpParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        expect(authEntity.password.strength, PasswordStrength.strong);
        verify(mockRepository.signUpWithEmailAndPassword(
          'user+special@domain.com',
          'Special!@#\$%^&*()Password123',
        )).called(1);
      });
    });

    group('Real-world Sign Up Scenarios', () {
      test('should handle typical user sign up attempts', () async {
        final signUpAttempts = [
          ('john.doe@gmail.com', 'MyPassword123!'),
          ('user@company.co.uk', 'SecurePass456@'),
          ('student@university.edu', 'StudentLife789#'),
        ];

        for (final (emailStr, passwordStr) in signUpAttempts) {
          final email = Email(emailStr);
          final password = Password(passwordStr);
          final authEntity = AuthEntityEnhanced(email: email, password: password);
          
          when(mockRepository.signUpWithEmailAndPassword(any, any))
              .thenAnswer((_) async => Right('user123'));

          final result = await useCase(SignUpParams(authEntity));

          expect(result, isA<Right<AuthFailure, String>>(), 
                 reason: '$emailStr with $passwordStr should succeed');
          expect(authEntity.password.strength, 
                 anyOf(PasswordStrength.medium, PasswordStrength.strong));
        }
      });

      test('should reject common weak sign up attempts', () async {
        final weakAttempts = [
          ('user@example.com', 'password'),
          ('test@domain.com', '123456'),
          ('new@user.com', 'simple'),
        ];

        for (final (emailStr, passwordStr) in weakAttempts) {
          final email = Email(emailStr);
          final password = Password(passwordStr);
          final authEntity = AuthEntityEnhanced(email: email, password: password);

          final result = await useCase(SignUpParams(authEntity));

          expect(result, isA<Left<AuthFailure, String>>(), 
                 reason: '$emailStr with $passwordStr should be rejected');
        }

        verifyNever(mockRepository.signUpWithEmailAndPassword(any, any));
      });
    });
  });
}