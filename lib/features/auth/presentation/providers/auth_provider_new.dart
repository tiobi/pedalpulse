import 'package:flutter/material.dart';
import '../../../../config/routes/routes.dart';
import '../../../../core/common/widgets/snack_bar_widget.dart';
import '../../../../core/errors/firebase_auth_failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../view_models/auth_view_model.dart';
import '../state/auth_state.dart';

class AuthProviderNew extends ChangeNotifier {
  final AuthViewModel _authViewModel;

  AuthProviderNew({required AuthViewModel authViewModel}) : _authViewModel = authViewModel {
    _authViewModel.addListener(_onViewModelChange);
  }

  AuthState get state => _authViewModel.state;

  void _onViewModelChange() {
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) async {
    await _authViewModel.sendPasswordResetEmail(email: email);

    if (_authViewModel.state.errorMessage != null) {
      if (_authViewModel.state.errorMessage == FirebaseAuthFailure.userNotFoundCode) {
        CustomSnackBar.showErrorSnackBar(context, 'User is not found');
      } else {
        CustomSnackBar.showErrorSnackBar(context, _authViewModel.state.errorMessage!);
      }
    } else if (_authViewModel.state.emailVerificationSent) {
      CustomSnackBar.showSuccessSnackBar(
        context,
        'Password reset email sent. Please check your email.',
      );
      Navigator.pushReplacementNamed(context, Routes.signIn);
      _authViewModel.resetEmailVerificationSent();
    }
  }

  Future<void> signInWithEmailAndPassword({
    required AuthEntity authEntity,
    required BuildContext context,
  }) async {
    await _authViewModel.signInWithEmailAndPassword(authEntity: authEntity);

    if (_authViewModel.state.errorMessage != null) {
      if (_authViewModel.state.errorMessage == FirebaseAuthFailure.userNotFoundCode) {
        CustomSnackBar.showErrorSnackBar(context, 'User not found');
      } else {
        CustomSnackBar.showErrorSnackBar(context, _authViewModel.state.errorMessage!);
      }
    } else if (_authViewModel.state.isAuthenticated) {
      CustomSnackBar.showSuccessSnackBar(context, 'Signed in');
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    await _authViewModel.signOut();

    if (_authViewModel.state.errorMessage != null) {
      CustomSnackBar.showErrorSnackBar(context, _authViewModel.state.errorMessage!);
    } else {
      CustomSnackBar.showSuccessSnackBar(
        context,
        'You are successfully signed out',
      );
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
    required BuildContext context,
  }) async {
    await _authViewModel.signUpWithEmailAndPassword(authEntity: authEntity);

    if (_authViewModel.state.errorMessage != null) {
      CustomSnackBar.showErrorSnackBar(context, _authViewModel.state.errorMessage!);
    } else if (_authViewModel.state.emailVerificationSent) {
      CustomSnackBar.showSuccessSnackBar(
        context,
        'Please check your email to verify',
      );
      Navigator.pushReplacementNamed(context, Routes.signIn);
      _authViewModel.resetEmailVerificationSent();
    }
  }

  Future<void> signInWithApple({required BuildContext context}) async {
    await _authViewModel.signInWithApple();

    if (_authViewModel.state.errorMessage != null) {
      CustomSnackBar.showErrorSnackBar(context, _authViewModel.state.errorMessage!);
    }
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    await _authViewModel.signInWithGoogle();

    if (_authViewModel.state.errorMessage != null) {
      CustomSnackBar.showErrorSnackBar(context, _authViewModel.state.errorMessage!);
    }
  }

  void clearError() {
    _authViewModel.clearError();
  }

  @override
  void dispose() {
    _authViewModel.removeListener(_onViewModelChange);
    super.dispose();
  }
}