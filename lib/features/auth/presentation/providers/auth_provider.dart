import 'package:flutter/material.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import '../../../../core/common/widgets/snack_bar_widget.dart';
import '../../domain/usecases/is_email_verified_usecase.dart';
import '../../domain/usecases/send_password_reset_email_usecase.dart';
import '../../domain/usecases/sign_in_with_email_and_password_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_with_email_and_password_usecase.dart';
import '../../domain/entities/auth_entity.dart';

class AuthProvider extends ChangeNotifier {
  IsEmailVerifiedUseCase isEmailVerifiedUseCase;
  SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  SignOutUseCase signOutUseCase;
  SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase;
  SignInWithAppleUseCase signInWithAppleUseCase;
  SignInWithGoogleUseCase signInWithGoogleUseCase;

  AuthProvider({
    required this.isEmailVerifiedUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.signInWithEmailAndPasswordUseCase,
    required this.signOutUseCase,
    required this.signUpWithEmailAndPasswordUseCase,
    required this.signInWithAppleUseCase,
    required this.signInWithGoogleUseCase,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    final result = await sendPasswordResetEmailUseCase(email: email);

    result.fold((failure) {
      CustomSnackBar.showErrorSnackBar(
          _scaffoldKey.currentState!.context, failure.message);
    }, (r) {
      CustomSnackBar.showSuccessSnackBar(_scaffoldKey.currentState!.context,
          'Password reset email sent. Please check your email.');
    });
  }

  Future<void> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    final result =
        await signInWithEmailAndPasswordUseCase(authEntity: authEntity);

    result.fold((l) {
      if (l.message == FirebaseAuthFailure.userNotFoundCode) {
        CustomSnackBar.showErrorSnackBar(
            _scaffoldKey.currentState!.context, 'User not found');
      } else {
        CustomSnackBar.showErrorSnackBar(
            _scaffoldKey.currentState!.context, l.message);
      }
    }, (r) {
      CustomSnackBar.showSuccessSnackBar(
          _scaffoldKey.currentState!.context, 'Signed in');
    });
  }

  Future<void> signOut() async {
    final result = await signOutUseCase();

    result.fold((failure) {
      CustomSnackBar.showErrorSnackBar(
          _scaffoldKey.currentState!.context, failure.message);
    }, (r) {
      CustomSnackBar.showSuccessSnackBar(
          _scaffoldKey.currentState!.context, 'Signed out');
    });
  }

  Future<void> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    final result =
        await signUpWithEmailAndPasswordUseCase(authEntity: authEntity);

    final BuildContext? context = _scaffoldKey.currentState?.context;

    if (context == null) {
      return;
    }

    result.fold((failure) {
      CustomSnackBar.showErrorSnackBar(
          _scaffoldKey.currentState!.context, failure.message);
    }, (r) {
      CustomSnackBar.showSuccessSnackBar(
          _scaffoldKey.currentState!.context, 'Signed up');
    });
  }
}
