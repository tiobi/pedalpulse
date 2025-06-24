import 'package:flutter/material.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/is_email_verified_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/usecases/sign_in_with_email_and_password_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_and_password_usecase.dart';
import '../../domain/entities/auth_entity.dart';
import '../state/auth_state.dart';

class AuthViewModel extends ChangeNotifier {
  final IsEmailVerifiedUseCase _isEmailVerifiedUseCase;
  final SendPasswordResetEmailUseCase _sendPasswordResetEmailUseCase;
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;
  final SignOutUseCase _signOutUseCase;
  final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPasswordUseCase;
  final SignInWithAppleUseCase _signInWithAppleUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  AuthViewModel({
    required IsEmailVerifiedUseCase isEmailVerifiedUseCase,
    required SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase,
    required SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase,
    required SignOutUseCase signOutUseCase,
    required SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase,
    required SignInWithAppleUseCase signInWithAppleUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
  })  : _isEmailVerifiedUseCase = isEmailVerifiedUseCase,
        _sendPasswordResetEmailUseCase = sendPasswordResetEmailUseCase,
        _signInWithEmailAndPasswordUseCase = signInWithEmailAndPasswordUseCase,
        _signOutUseCase = signOutUseCase,
        _signUpWithEmailAndPasswordUseCase = signUpWithEmailAndPasswordUseCase,
        _signInWithAppleUseCase = signInWithAppleUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase;

  AuthState _state = const AuthState();
  AuthState get state => _state;

  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _sendPasswordResetEmailUseCase(email: email);

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (_) {
        _updateState(_state.copyWith(
          isLoading: false,
          emailVerificationSent: true,
        ));
      },
    );
  }

  Future<void> signInWithEmailAndPassword({required AuthEntity authEntity}) async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _signInWithEmailAndPasswordUseCase(authEntity: authEntity);

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (userCredential) {
        _updateState(_state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userUid: userCredential.user?.uid,
        ));
      },
    );
  }

  Future<void> signOut() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _signOutUseCase();

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (_) {
        _updateState(_state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          userUid: null,
        ));
      },
    );
  }

  Future<void> signUpWithEmailAndPassword({required AuthEntity authEntity}) async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _signUpWithEmailAndPasswordUseCase(authEntity: authEntity);

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (_) {
        _updateState(_state.copyWith(
          isLoading: false,
          emailVerificationSent: true,
        ));
      },
    );
  }

  Future<void> signInWithApple() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _signInWithAppleUseCase();

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (userCredential) {
        _updateState(_state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userUid: userCredential.user?.uid,
        ));
      },
    );
  }

  Future<void> signInWithGoogle() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _signInWithGoogleUseCase();

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (userCredential) {
        _updateState(_state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userUid: userCredential.user?.uid,
        ));
      },
    );
  }

  void clearError() {
    _updateState(_state.copyWith(errorMessage: null));
  }

  void resetEmailVerificationSent() {
    _updateState(_state.copyWith(emailVerificationSent: false));
  }
}