import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/sign_in_with_email_and_password_usecase.dart';
import '../../domain/usecases/sign_up_with_email_and_password_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_in_with_apple_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/usecases/is_email_verified_usecase.dart';
import '../../domain/usecases/get_current_user_uid_usecase.dart';
import '../state/auth_state.dart';

class AuthViewModel extends ChangeNotifier {
  // Use cases
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  final SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithAppleUseCase signInWithAppleUseCase;
  final SignOutUseCase signOutUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  final IsEmailVerifiedUseCase isEmailVerifiedUseCase;
  final GetCurrentUserUidUseCase getCurrentUserUidUseCase;

  // State
  AuthState _state = AuthState.initial();
  AuthState get state => _state;

  // Constructor
  AuthViewModel({
    required this.signInWithEmailAndPasswordUseCase,
    required this.signUpWithEmailAndPasswordUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithAppleUseCase,
    required this.signOutUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.isEmailVerifiedUseCase,
    required this.getCurrentUserUidUseCase,
  }) {
    _initialize();
  }

  // Private methods
  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void _initialize() async {
    try {
      final result = await getCurrentUserUidUseCase();
      result.fold(
        (failure) => _updateState(AuthState.unauthenticated()),
        (uid) async {
          // User is signed in, check email verification
          final emailVerificationResult = await isEmailVerifiedUseCase(email: '');
          final isEmailVerified = emailVerificationResult.fold(
            (failure) => false,
            (verified) => verified,
          );

          _updateState(AuthState.authenticated(
            userUid: uid,
            email: '', // You might want to get email from user data
            isEmailVerified: isEmailVerified,
            authType: const AuthType.emailPassword(),
          ));
        },
      );
    } catch (e) {
      _updateState(AuthState.unauthenticated());
    }
  }

  // Public methods for authentication actions

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!_state.canPerformAuth) return;

    _updateState(AuthState.loading());

    final result = await signInWithEmailAndPasswordUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => _updateState(AuthState.error(errorMessage: failure.message)),
      (userCredential) async {
        final user = userCredential.user;
        if (user != null) {
          _updateState(AuthState.authenticated(
            userUid: user.uid,
            email: user.email ?? email,
            isEmailVerified: user.emailVerified,
            authType: const AuthType.emailPassword(),
            successMessage: 'Successfully signed in',
          ));
        } else {
          _updateState(AuthState.error(errorMessage: 'Sign in failed'));
        }
      },
    );
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!_state.canPerformAuth) return;

    _updateState(AuthState.loading());

    final result = await signUpWithEmailAndPasswordUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => _updateState(AuthState.error(errorMessage: failure.message)),
      (userCredential) async {
        final user = userCredential.user;
        if (user != null) {
          _updateState(AuthState.authenticated(
            userUid: user.uid,
            email: user.email ?? email,
            isEmailVerified: user.emailVerified,
            authType: const AuthType.emailPassword(),
            successMessage: user.emailVerified 
                ? 'Account created successfully' 
                : 'Account created. Please verify your email.',
          ));
        } else {
          _updateState(AuthState.error(errorMessage: 'Sign up failed'));
        }
      },
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    if (!_state.canPerformAuth) return;

    _updateState(AuthState.loading());

    final result = await signInWithGoogleUseCase();

    result.fold(
      (failure) => _updateState(AuthState.error(errorMessage: failure.message)),
      (userCredential) async {
        final user = userCredential.user;
        if (user != null) {
          _updateState(AuthState.authenticated(
            userUid: user.uid,
            email: user.email ?? '',
            isEmailVerified: user.emailVerified,
            authType: const AuthType.google(),
            successMessage: 'Successfully signed in with Google',
          ));
        } else {
          _updateState(AuthState.error(errorMessage: 'Google sign in failed'));
        }
      },
    );
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    if (!_state.canPerformAuth) return;

    _updateState(AuthState.loading());

    final result = await signInWithAppleUseCase();

    result.fold(
      (failure) => _updateState(AuthState.error(errorMessage: failure.message)),
      (userCredential) async {
        final user = userCredential.user;
        if (user != null) {
          _updateState(AuthState.authenticated(
            userUid: user.uid,
            email: user.email ?? '',
            isEmailVerified: user.emailVerified,
            authType: const AuthType.apple(),
            successMessage: 'Successfully signed in with Apple',
          ));
        } else {
          _updateState(AuthState.error(errorMessage: 'Apple sign in failed'));
        }
      },
    );
  }

  /// Sign out
  Future<void> signOut() async {
    _updateState(AuthState.loading());

    final result = await signOutUseCase();

    result.fold(
      (failure) => _updateState(AuthState.error(
        errorMessage: failure.message,
        wasAuthenticated: true,
      )),
      (_) => _updateState(AuthState.unauthenticated()),
    );
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    if (!_state.canPerformAuth) return;

    _updateState(AuthState.loading());

    final result = await sendPasswordResetEmailUseCase(email: email);

    result.fold(
      (failure) => _updateState(AuthState.error(errorMessage: failure.message)),
      (_) => _updateState(_state.copyWith(
        isLoading: false,
        successMessage: 'Password reset email sent',
        errorMessage: null,
      )),
    );
  }

  /// Clear messages
  void clearMessages() {
    _updateState(_state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }

  /// Reset to initial state
  void reset() {
    _updateState(AuthState.initial());
  }

  @override
  void dispose() {
    super.dispose();
  }
}