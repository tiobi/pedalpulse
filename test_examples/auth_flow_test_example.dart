import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../lib/features/auth/domain/entities/auth_entity_enhanced.dart';
import '../lib/features/auth/domain/value_objects/email.dart';
import '../lib/features/auth/domain/value_objects/password.dart';
import '../lib/features/auth/domain/usecases/sign_in_with_email_and_password_usecase_enhanced.dart';
import '../lib/features/auth/domain/usecases/sign_up_with_email_and_password_usecase_enhanced.dart';
import '../lib/features/auth/presentation/view_models/auth_view_model.dart';
import '../lib/features/auth/presentation/state/auth_state.dart';
import '../lib/core/errors/failure.dart';

class MockFirebaseAuthRepositoryNew extends Mock {}
class MockSignInUseCase extends Mock {}
class MockSignUpUseCase extends Mock {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('Auth Flow Tests', () {
    late AuthViewModel authViewModel;
    late MockSignInUseCase mockSignInUseCase;
    late MockSignUpUseCase mockSignUpUseCase;

    setUp(() {
      mockSignInUseCase = MockSignInUseCase();
      mockSignUpUseCase = MockSignUpUseCase();
    });

    group('Enhanced Auth Entity Validation', () {
      test('should validate email correctly', () {
        final email = Email('test@example.com');
        expect(email.isValid, true);
        expect(email.error, null);
      });

      test('should invalidate incorrect email', () {
        final email = Email('invalid-email');
        expect(email.isValid, false);
        expect(email.error, 'Please enter a valid email address');
      });

      test('should validate password strength', () {
        final weakPassword = Password('123');
        final strongPassword = Password('StrongPass123!');

        expect(weakPassword.strength, PasswordStrength.weak);
        expect(strongPassword.strength, PasswordStrength.strong);
      });

      test('should create valid auth entity', () {
        final authEntity = AuthEntityEnhanced.create(
          email: 'user@example.com',
          password: 'ValidPass123!',
        );

        expect(authEntity.isValid, true);
        expect(authEntity.validationError, null);
      });

      test('should reject invalid auth entity', () {
        final authEntity = AuthEntityEnhanced.create(
          email: 'invalid-email',
          password: '123',
        );

        expect(authEntity.isValid, false);
        expect(authEntity.validationError, isNotNull);
      });
    });

    group('Sign In Use Case', () {
      test('should sign in with valid credentials', () async {
        final repository = MockFirebaseAuthRepositoryNew();
        final useCase = SignInWithEmailAndPasswordUseCaseEnhanced(
          repository: repository,
        );
        final userCredential = MockUserCredential();
        
        final authEntity = AuthEntityEnhanced.create(
          email: 'test@example.com',
          password: 'ValidPass123!',
        );

        when(repository.signInWithEmailAndPassword(authEntity: any))
            .thenAnswer((_) async => Right(userCredential));

        final result = await useCase(authEntity: authEntity);

        expect(result.isRight(), true);
        verify(repository.signInWithEmailAndPassword(authEntity: any));
      });

      test('should reject invalid credentials', () async {
        final repository = MockFirebaseAuthRepositoryNew();
        final useCase = SignInWithEmailAndPasswordUseCaseEnhanced(
          repository: repository,
        );
        
        final authEntity = AuthEntityEnhanced.create(
          email: 'invalid-email',
          password: '123',
        );

        final result = await useCase(authEntity: authEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('email')),
          (_) => fail('Should have failed'),
        );
      });
    });

    group('Sign Up Use Case', () {
      test('should sign up with strong password', () async {
        final repository = MockFirebaseAuthRepositoryNew();
        final useCase = SignUpWithEmailAndPasswordUseCaseEnhanced(
          repository: repository,
        );
        final userCredential = MockUserCredential();
        
        final authEntity = AuthEntityEnhanced.create(
          email: 'test@example.com',
          password: 'StrongPass123!',
        );

        when(repository.signUpWithEmailAndPassword(authEntity: any))
            .thenAnswer((_) async => Right(userCredential));

        final result = await useCase(authEntity: authEntity);

        expect(result.isRight(), true);
      });

      test('should reject weak password', () async {
        final repository = MockFirebaseAuthRepositoryNew();
        final useCase = SignUpWithEmailAndPasswordUseCaseEnhanced(
          repository: repository,
        );
        
        final authEntity = AuthEntityEnhanced.create(
          email: 'test@example.com',
          password: 'weak',
        );

        final result = await useCase(authEntity: authEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('too weak')),
          (_) => fail('Should have failed'),
        );
      });
    });

    group('Auth State Management', () {
      test('should initialize with correct default state', () {
        const authState = AuthState();

        expect(authState.isLoading, false);
        expect(authState.isAuthenticated, false);
        expect(authState.userUid, null);
        expect(authState.errorMessage, null);
        expect(authState.emailVerificationSent, false);
      });

      test('should update loading state correctly', () {
        const initialState = AuthState();
        final loadingState = initialState.copyWith(isLoading: true);

        expect(loadingState.isLoading, true);
        expect(loadingState.isAuthenticated, false);
      });

      test('should update authenticated state correctly', () {
        const initialState = AuthState();
        final authenticatedState = initialState.copyWith(
          isAuthenticated: true,
          userUid: 'test-uid',
        );

        expect(authenticatedState.isAuthenticated, true);
        expect(authenticatedState.userUid, 'test-uid');
      });
    });
  });
}

class TestAuthFlow {
  static Future<void> runFullAuthFlow() async {
    print('🧪 Testing Full Auth Flow...');
    
    print('1. Creating valid auth entity...');
    final authEntity = AuthEntityEnhanced.create(
      email: 'test@example.com',
      password: 'StrongPass123!',
    );
    
    assert(authEntity.isValid, 'Auth entity should be valid');
    print('✅ Auth entity created and validated');
    
    print('2. Testing password strength...');
    assert(authEntity.password.strength == PasswordStrength.strong,
           'Password should be strong');
    print('✅ Password strength validated');
    
    print('3. Testing email validation...');
    assert(authEntity.email.isValid, 'Email should be valid');
    print('✅ Email validation passed');
    
    print('4. Testing invalid credentials...');
    final invalidEntity = AuthEntityEnhanced.create(
      email: 'invalid-email',
      password: '123',
    );
    
    assert(!invalidEntity.isValid, 'Invalid entity should be rejected');
    assert(invalidEntity.validationError != null, 'Should have validation error');
    print('✅ Invalid credentials properly rejected');
    
    print('🎉 All auth flow tests passed!');
  }
}