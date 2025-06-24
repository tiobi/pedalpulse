import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_email_and_password_usecase_enhanced.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository_new.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity_enhanced.dart';
import 'package:pedalpulse/features/auth/domain/value_objects/email.dart';
import 'package:pedalpulse/features/auth/domain/value_objects/password.dart';
import 'package:pedalpulse/core/errors/auth_failure.dart';

@GenerateMocks([FirebaseAuthRepositoryNew])
import 'sign_in_with_email_and_password_usecase_enhanced_test.mocks.dart';

void main() {
  group('SignInWithEmailAndPasswordUseCaseEnhanced', () {
    late SignInWithEmailAndPasswordUseCaseEnhanced useCase;
    late MockFirebaseAuthRepositoryNew mockRepository;

    setUp(() {
      mockRepository = MockFirebaseAuthRepositoryNew();
      useCase = SignInWithEmailAndPasswordUseCaseEnhanced(repository: mockRepository);
    });

    group('Valid Sign In', () {
      test('should sign in successfully with valid credentials', () async {
        final email = Email('test@example.com');
        final password = Password('ValidPass123!');
        final authEntity = AuthEntityEnhanced(email: email, password: password);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (uid) => expect(uid, 'user123'),
        );

        verify(mockRepository.signInWithEmailAndPassword(
          'test@example.com',
          'ValidPass123!',
        )).called(1);
      });

      test('should handle different valid email formats', () async {
        final testCases = [
          'user@domain.com',
          'user.name@company.co.uk',
          'user+tag@example.org',
        ];

        for (final emailStr in testCases) {
          final email = Email(emailStr);
          final password = Password('ValidPass123!');
          final authEntity = AuthEntityEnhanced(email: email, password: password);
          
          when(mockRepository.signInWithEmailAndPassword(any, any))
              .thenAnswer((_) async => Right('user123'));

          final result = await useCase(SignInParams(authEntity));

          expect(result, isA<Right<AuthFailure, String>>());
          verify(mockRepository.signInWithEmailAndPassword(emailStr, 'ValidPass123!')).called(1);
        }
      });
    });

    group('Domain Validation', () {
      test('should fail for invalid email format', () async {
        final invalidEmail = Email('invalid-email');
        final validPassword = Password('ValidPass123!');
        final authEntity = AuthEntityEnhanced(email: invalidEmail, password: validPassword);

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Please enter a valid email address'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signInWithEmailAndPassword(any, any));
      });

      test('should fail for invalid password', () async {
        final validEmail = Email('test@example.com');
        final invalidPassword = Password('123');
        final authEntity = AuthEntityEnhanced(email: validEmail, password: invalidPassword);

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Password must be at least 6 characters long'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signInWithEmailAndPassword(any, any));
      });

      test('should fail for both invalid email and password', () async {
        final invalidEmail = Email('invalid');
        final invalidPassword = Password('123');
        final authEntity = AuthEntityEnhanced(email: invalidEmail, password: invalidPassword);

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Please enter a valid email address'));
            expect(failure.message, contains('Password must be at least 6 characters long'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signInWithEmailAndPassword(any, any));
      });

      test('should fail for empty credentials', () async {
        final emptyEmail = Email('');
        final emptyPassword = Password('');
        final authEntity = AuthEntityEnhanced(email: emptyEmail, password: emptyPassword);

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, contains('Email cannot be empty'));
            expect(failure.message, contains('Password cannot be empty'));
          },
          (uid) => fail('Expected failure but got success: $uid'),
        );

        verifyNever(mockRepository.signInWithEmailAndPassword(any, any));
      });
    });

    group('Repository Failures', () {
      test('should handle user not found error', () async {
        final email = Email('test@example.com');
        final password = Password('ValidPass123!');
        final authEntity = AuthEntityEnhanced(email: email, password: password);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Left(AuthFailure('User not found')));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) => expect(failure.message, 'User not found'),
          (uid) => fail('Expected failure but got success: $uid'),
        );
      });

      test('should handle wrong password error', () async {
        final email = Email('test@example.com');
        final password = Password('WrongPass123!');
        final authEntity = AuthEntityEnhanced(email: email, password: password);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Left(AuthFailure('Wrong password')));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) => expect(failure.message, 'Wrong password'),
          (uid) => fail('Expected failure but got success: $uid'),
        );
      });

      test('should handle network errors', () async {
        final email = Email('test@example.com');
        final password = Password('ValidPass123!');
        final authEntity = AuthEntityEnhanced(email: email, password: password);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Left(AuthFailure('Network error')));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Left<AuthFailure, String>>());
        result.fold(
          (failure) => expect(failure.message, 'Network error'),
          (uid) => fail('Expected failure but got success: $uid'),
        );
      });
    });

    group('Edge Cases', () {
      test('should handle minimum valid credentials', () async {
        final email = Email('a@b.co');
        final password = Password('123456');
        final authEntity = AuthEntityEnhanced(email: email, password: password);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        verify(mockRepository.signInWithEmailAndPassword('a@b.co', '123456')).called(1);
      });

      test('should handle long email and password', () async {
        final email = Email('verylongemailaddress@verylongdomainname.com');
        final password = Password('VeryLongPassword123!@#');
        final authEntity = AuthEntityEnhanced(email: email, password: password);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        verify(mockRepository.signInWithEmailAndPassword(
          'verylongemailaddress@verylongdomainname.com',
          'VeryLongPassword123!@#',
        )).called(1);
      });

      test('should handle special characters in credentials', () async {
        final email = Email('user+special@domain.com');
        final password = Password('Special!@#\$%Password123');
        final authEntity = AuthEntityEnhanced(email: email, password: password);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        verify(mockRepository.signInWithEmailAndPassword(
          'user+special@domain.com',
          'Special!@#\$%Password123',
        )).called(1);
      });
    });

    group('Password Strength Considerations', () {
      test('should accept weak but valid passwords for sign in', () async {
        final email = Email('test@example.com');
        final weakPassword = Password('password');
        final authEntity = AuthEntityEnhanced(email: email, password: weakPassword);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        expect(authEntity.password.strength, PasswordStrength.weak);
        verify(mockRepository.signInWithEmailAndPassword('test@example.com', 'password')).called(1);
      });

      test('should accept medium strength passwords', () async {
        final email = Email('test@example.com');
        final mediumPassword = Password('Password123');
        final authEntity = AuthEntityEnhanced(email: email, password: mediumPassword);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        expect(authEntity.password.strength, PasswordStrength.medium);
        verify(mockRepository.signInWithEmailAndPassword('test@example.com', 'Password123')).called(1);
      });

      test('should accept strong passwords', () async {
        final email = Email('test@example.com');
        final strongPassword = Password('StrongPass123!@#');
        final authEntity = AuthEntityEnhanced(email: email, password: strongPassword);
        
        when(mockRepository.signInWithEmailAndPassword(any, any))
            .thenAnswer((_) async => Right('user123'));

        final result = await useCase(SignInParams(authEntity));

        expect(result, isA<Right<AuthFailure, String>>());
        expect(authEntity.password.strength, PasswordStrength.strong);
        verify(mockRepository.signInWithEmailAndPassword('test@example.com', 'StrongPass123!@#')).called(1);
      });
    });
  });
}