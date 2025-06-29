import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthEntity', () {
    group('Email validation', () {
      test('should return true for valid email addresses', () {
        const validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
          'user123@test-domain.com',
        ];

        for (final email in validEmails) {
          final authEntity = AuthEntity(
            email: email,
            password: 'password123',
            authType: const AuthType.emailPassword(),
          );

          expect(authEntity.isEmailValid, true,
              reason: '$email should be valid');
        }
      });

      test('should return false for invalid email addresses', () {
        const invalidEmails = [
          'invalid-email',
          '@domain.com',
          'user@',
          'user.domain.com',
          '',
          'user @domain.com',
        ];

        for (final email in invalidEmails) {
          final authEntity = AuthEntity(
            email: email,
            password: 'password123',
            authType: const AuthType.emailPassword(),
          );

          expect(authEntity.isEmailValid, false,
              reason: '$email should be invalid');
        }
      });
    });

    group('Password validation', () {
      test('should return true for valid passwords when using email/password auth',
          () {
        const validPasswords = [
          'password123',
          '123456',
          'P@ssw0rd!',
          'verylongpassword',
        ];

        for (final password in validPasswords) {
          final authEntity = AuthEntity(
            email: 'test@example.com',
            password: password,
            authType: const AuthType.emailPassword(),
          );

          expect(authEntity.isPasswordValid, true,
              reason: '$password should be valid');
        }
      });

      test('should return false for invalid passwords when using email/password auth',
          () {
        const invalidPasswords = [
          'short',
          '12345',
          '',
        ];

        for (final password in invalidPasswords) {
          final authEntity = AuthEntity(
            email: 'test@example.com',
            password: password,
            authType: const AuthType.emailPassword(),
          );

          expect(authEntity.isPasswordValid, false,
              reason: '$password should be invalid');
        }
      });

      test('should return true for null password when using social auth', () {
        const socialAuthTypes = [
          AuthType.google(),
          AuthType.apple(),
          AuthType.anonymous(),
        ];

        for (final authType in socialAuthTypes) {
          final authEntity = AuthEntity(
            email: 'test@example.com',
            authType: authType,
          );

          expect(authEntity.isPasswordValid, true,
              reason: 'Password should not be required for ${authType.toString()}');
        }
      });
    });

    group('Overall validation', () {
      test('should return true for valid email/password auth', () {
        const authEntity = AuthEntity(
          email: 'test@example.com',
          password: 'password123',
          authType: AuthType.emailPassword(),
        );

        expect(authEntity.isValid, true);
      });

      test('should return false for invalid email with valid password', () {
        const authEntity = AuthEntity(
          email: 'invalid-email',
          password: 'password123',
          authType: AuthType.emailPassword(),
        );

        expect(authEntity.isValid, false);
      });

      test('should return false for valid email with invalid password', () {
        const authEntity = AuthEntity(
          email: 'test@example.com',
          password: 'short',
          authType: AuthType.emailPassword(),
        );

        expect(authEntity.isValid, false);
      });

      test('should return true for valid social auth', () {
        const authEntity = AuthEntity(
          email: 'test@example.com',
          authType: AuthType.google(),
          socialData: {'accessToken': 'token123'},
        );

        expect(authEntity.isValid, true);
      });
    });

    group('Factory constructors and immutability', () {
      test('should create AuthEntity with required fields', () {
        const authEntity = AuthEntity(
          email: 'test@example.com',
          password: 'password123',
          authType: AuthType.emailPassword(),
        );

        expect(authEntity.email, 'test@example.com');
        expect(authEntity.password, 'password123');
        expect(authEntity.authType, const AuthType.emailPassword());
        expect(authEntity.socialData, isNull);
      });

      test('should create AuthEntity with social data', () {
        const socialData = {'accessToken': 'token123', 'refreshToken': 'refresh456'};
        const authEntity = AuthEntity(
          email: 'test@example.com',
          authType: AuthType.google(),
          socialData: socialData,
        );

        expect(authEntity.email, 'test@example.com');
        expect(authEntity.password, isNull);
        expect(authEntity.authType, const AuthType.google());
        expect(authEntity.socialData, socialData);
      });

      test('should support copyWith functionality', () {
        const original = AuthEntity(
          email: 'test@example.com',
          password: 'password123',
          authType: AuthType.emailPassword(),
        );

        final updated = original.copyWith(password: 'newpassword456');

        expect(updated.email, 'test@example.com');
        expect(updated.password, 'newpassword456');
        expect(updated.authType, const AuthType.emailPassword());
        expect(original.password, 'password123'); // Original unchanged
      });
    });

    group('JSON serialization', () {
      test('should serialize to and from JSON correctly', () {
        const original = AuthEntity(
          email: 'test@example.com',
          password: 'password123',
          authType: AuthType.emailPassword(),
          socialData: {'key': 'value'},
        );

        final json = original.toJson();
        final deserialized = AuthEntity.fromJson(json);

        expect(deserialized.email, original.email);
        expect(deserialized.password, original.password);
        expect(deserialized.authType, original.authType);
        expect(deserialized.socialData, original.socialData);
      });
    });
  });

  group('AuthState', () {
    test('should create initial state correctly', () {
      final state = AuthState.initial();

      expect(state.isAuthenticated, false);
      expect(state.isEmailVerified, false);
      expect(state.isLoading, false);
      expect(state.userUid, isNull);
      expect(state.email, isNull);
      expect(state.authType, isNull);
      expect(state.errorMessage, isNull);
    });

    test('should create loading state correctly', () {
      final state = AuthState.loading();

      expect(state.isAuthenticated, false);
      expect(state.isEmailVerified, false);
      expect(state.isLoading, true);
      expect(state.userUid, isNull);
      expect(state.email, isNull);
      expect(state.authType, isNull);
      expect(state.errorMessage, isNull);
    });

    test('should create authenticated state correctly', () {
      final state = AuthState.authenticated(
        userUid: 'uid123',
        email: 'test@example.com',
        isEmailVerified: true,
        authType: const AuthType.emailPassword(),
      );

      expect(state.isAuthenticated, true);
      expect(state.isEmailVerified, true);
      expect(state.isLoading, false);
      expect(state.userUid, 'uid123');
      expect(state.email, 'test@example.com');
      expect(state.authType, const AuthType.emailPassword());
      expect(state.errorMessage, isNull);
    });

    test('should create unauthenticated state correctly', () {
      final state = AuthState.unauthenticated(errorMessage: 'Login failed');

      expect(state.isAuthenticated, false);
      expect(state.isEmailVerified, false);
      expect(state.isLoading, false);
      expect(state.userUid, isNull);
      expect(state.email, isNull);
      expect(state.authType, isNull);
      expect(state.errorMessage, 'Login failed');
    });

    test('should support copyWith functionality', () {
      final original = AuthState.initial();
      final updated = original.copyWith(
        isLoading: true,
        errorMessage: 'An error occurred',
      );

      expect(updated.isAuthenticated, false);
      expect(updated.isEmailVerified, false);
      expect(updated.isLoading, true);
      expect(updated.errorMessage, 'An error occurred');
      expect(original.isLoading, false); // Original unchanged
    });
  });

  group('AuthType', () {
    test('should create different auth types correctly', () {
      const emailPassword = AuthType.emailPassword();
      const google = AuthType.google();
      const apple = AuthType.apple();
      const anonymous = AuthType.anonymous();

      expect(emailPassword, isA<EmailPassword>());
      expect(google, isA<Google>());
      expect(apple, isA<Apple>());
      expect(anonymous, isA<Anonymous>());
    });

    test('should support pattern matching with when', () {
      const authType = AuthType.google();

      final result = authType.when(
        emailPassword: () => 'email',
        google: () => 'google',
        apple: () => 'apple',
        anonymous: () => 'anonymous',
      );

      expect(result, 'google');
    });
  });
}