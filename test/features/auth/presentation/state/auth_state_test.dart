import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';
import 'package:pedalpulse/features/auth/presentation/state/auth_state.dart';

void main() {
  group('AuthState', () {
    group('Factory constructors', () {
      test('should create initial state correctly', () {
        final state = AuthState.initial();

        expect(state.isAuthenticated, false);
        expect(state.isEmailVerified, false);
        expect(state.isLoading, false);
        expect(state.isInitializing, true);
        expect(state.userUid, isNull);
        expect(state.email, isNull);
        expect(state.authType, isNull);
        expect(state.errorMessage, isNull);
        expect(state.successMessage, isNull);
      });

      test('should create loading state correctly', () {
        final state = AuthState.loading();

        expect(state.isAuthenticated, false);
        expect(state.isEmailVerified, false);
        expect(state.isLoading, true);
        expect(state.isInitializing, false);
        expect(state.userUid, isNull);
        expect(state.email, isNull);
        expect(state.authType, isNull);
        expect(state.errorMessage, isNull);
        expect(state.successMessage, isNull);
      });

      test('should create authenticated state correctly', () {
        final state = AuthState.authenticated(
          userUid: 'uid123',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.emailPassword(),
          successMessage: 'Welcome back!',
        );

        expect(state.isAuthenticated, true);
        expect(state.isEmailVerified, true);
        expect(state.isLoading, false);
        expect(state.isInitializing, false);
        expect(state.userUid, 'uid123');
        expect(state.email, 'test@example.com');
        expect(state.authType, const AuthType.emailPassword());
        expect(state.errorMessage, isNull);
        expect(state.successMessage, 'Welcome back!');
      });

      test('should create unauthenticated state correctly', () {
        final state = AuthState.unauthenticated(
          errorMessage: 'Invalid credentials',
        );

        expect(state.isAuthenticated, false);
        expect(state.isEmailVerified, false);
        expect(state.isLoading, false);
        expect(state.isInitializing, false);
        expect(state.userUid, isNull);
        expect(state.email, isNull);
        expect(state.authType, isNull);
        expect(state.errorMessage, 'Invalid credentials');
        expect(state.successMessage, isNull);
      });

      test('should create error state correctly', () {
        final state = AuthState.error(
          errorMessage: 'Network error',
          wasAuthenticated: true,
        );

        expect(state.isAuthenticated, true);
        expect(state.isEmailVerified, false);
        expect(state.isLoading, false);
        expect(state.isInitializing, false);
        expect(state.userUid, isNull);
        expect(state.email, isNull);
        expect(state.authType, isNull);
        expect(state.errorMessage, 'Network error');
        expect(state.successMessage, isNull);
      });

      test('should create error state with default authentication status', () {
        final state = AuthState.error(errorMessage: 'Some error');

        expect(state.isAuthenticated, false);
        expect(state.errorMessage, 'Some error');
      });
    });

    group('Extensions', () {
      test('should correctly identify error state', () {
        final stateWithError = AuthState.error(errorMessage: 'Error');
        final stateWithoutError = AuthState.initial();

        expect(stateWithError.hasError, true);
        expect(stateWithoutError.hasError, false);
      });

      test('should correctly identify success state', () {
        final stateWithSuccess = AuthState.authenticated(
          userUid: 'uid',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.google(),
          successMessage: 'Success!',
        );
        final stateWithoutSuccess = AuthState.initial();

        expect(stateWithSuccess.hasSuccess, true);
        expect(stateWithoutSuccess.hasSuccess, false);
      });

      test('should correctly identify ready state', () {
        final readyState = AuthState.authenticated(
          userUid: 'uid',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.apple(),
        );
        final loadingState = AuthState.loading();
        final initializingState = AuthState.initial();

        expect(readyState.isReady, true);
        expect(loadingState.isReady, false);
        expect(initializingState.isReady, false);
      });

      test('should correctly identify when auth operations can be performed', () {
        final readyState = AuthState.unauthenticated();
        final loadingState = AuthState.loading();
        final initializingState = AuthState.initial();

        expect(readyState.canPerformAuth, true);
        expect(loadingState.canPerformAuth, false);
        expect(initializingState.canPerformAuth, false);
      });
    });

    group('Immutability and copyWith', () {
      test('should support copyWith functionality', () {
        final original = AuthState.initial();
        final updated = original.copyWith(
          isLoading: true,
          errorMessage: 'Test error',
        );

        expect(updated.isLoading, true);
        expect(updated.errorMessage, 'Test error');
        expect(updated.isAuthenticated, false); // Unchanged
        expect(updated.isInitializing, true); // Unchanged
        expect(original.isLoading, false); // Original unchanged
        expect(original.errorMessage, isNull); // Original unchanged
      });

      test('should handle null values in copyWith', () {
        final stateWithError = AuthState.error(errorMessage: 'Error');
        final clearedState = stateWithError.copyWith(errorMessage: null);

        expect(stateWithError.errorMessage, 'Error');
        expect(clearedState.errorMessage, isNull);
      });
    });

    group('Equality and hashCode', () {
      test('should be equal when all properties are the same', () {
        final state1 = AuthState.authenticated(
          userUid: 'uid123',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.emailPassword(),
        );
        final state2 = AuthState.authenticated(
          userUid: 'uid123',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.emailPassword(),
        );

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when properties differ', () {
        final state1 = AuthState.authenticated(
          userUid: 'uid123',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.emailPassword(),
        );
        final state2 = AuthState.authenticated(
          userUid: 'uid456',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.emailPassword(),
        );

        expect(state1, isNot(equals(state2)));
      });
    });

    group('JSON serialization', () {
      test('should serialize and deserialize correctly', () {
        final original = AuthState.authenticated(
          userUid: 'uid123',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.google(),
          successMessage: 'Welcome!',
        );

        final json = original.toJson();
        final deserialized = AuthState.fromJson(json);

        expect(deserialized.isAuthenticated, original.isAuthenticated);
        expect(deserialized.isEmailVerified, original.isEmailVerified);
        expect(deserialized.isLoading, original.isLoading);
        expect(deserialized.isInitializing, original.isInitializing);
        expect(deserialized.userUid, original.userUid);
        expect(deserialized.email, original.email);
        expect(deserialized.authType, original.authType);
        expect(deserialized.successMessage, original.successMessage);
      });

      test('should handle null values in JSON serialization', () {
        final original = AuthState.initial();

        final json = original.toJson();
        final deserialized = AuthState.fromJson(json);

        expect(deserialized.userUid, isNull);
        expect(deserialized.email, isNull);
        expect(deserialized.authType, isNull);
        expect(deserialized.errorMessage, isNull);
        expect(deserialized.successMessage, isNull);
      });
    });

    group('State transitions', () {
      test('should transition from initial to loading', () {
        final initial = AuthState.initial();
        final loading = AuthState.loading();

        expect(initial.isInitializing, true);
        expect(initial.isLoading, false);
        expect(loading.isInitializing, false);
        expect(loading.isLoading, true);
      });

      test('should transition from loading to authenticated', () {
        final loading = AuthState.loading();
        final authenticated = AuthState.authenticated(
          userUid: 'uid',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.emailPassword(),
        );

        expect(loading.isLoading, true);
        expect(loading.isAuthenticated, false);
        expect(authenticated.isLoading, false);
        expect(authenticated.isAuthenticated, true);
      });

      test('should transition from authenticated to unauthenticated', () {
        final authenticated = AuthState.authenticated(
          userUid: 'uid',
          email: 'test@example.com',
          isEmailVerified: true,
          authType: const AuthType.emailPassword(),
        );
        final unauthenticated = AuthState.unauthenticated();

        expect(authenticated.isAuthenticated, true);
        expect(authenticated.userUid, isNotNull);
        expect(unauthenticated.isAuthenticated, false);
        expect(unauthenticated.userUid, isNull);
      });
    });
  });
}