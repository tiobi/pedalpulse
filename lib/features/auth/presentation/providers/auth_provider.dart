import 'package:flutter/material.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/core/routes/routes.dart';
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

  Future<void> sendPasswordResetEmail({
    required String email,
    required BuildContext context,
  }) async {
    final result = await sendPasswordResetEmailUseCase(email: email);

    result.fold((failure) {
      CustomSnackBar.showErrorSnackBar(context, failure.message);
    }, (r) {
      CustomSnackBar.showSuccessSnackBar(
          context, 'Password reset email sent. Please check your email.');
    });
  }

  Future<void> signInWithEmailAndPassword({
    required AuthEntity authEntity,
    required BuildContext context,
  }) async {
    final result =
        await signInWithEmailAndPasswordUseCase(authEntity: authEntity);

    result.fold((l) {
      if (l.message == FirebaseAuthFailure.userNotFoundCode) {
        CustomSnackBar.showErrorSnackBar(context, 'User not found');
      } else {
        CustomSnackBar.showErrorSnackBar(context, l.message);
      }
    }, (r) {
      CustomSnackBar.showSuccessSnackBar(context, 'Signed in');
    });
  }

  Future<void> signOut({
    required BuildContext context,
  }) async {
    final result = await signOutUseCase();

    result.fold((failure) {
      CustomSnackBar.showErrorSnackBar(context, failure.message);
    }, (r) {
      CustomSnackBar.showSuccessSnackBar(context, 'Signed out');
    });
  }

  Future<void> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
    required BuildContext context,
  }) async {
    final result =
        await signUpWithEmailAndPasswordUseCase(authEntity: authEntity);

    result.fold((failure) {
      CustomSnackBar.showErrorSnackBar(context, failure.message);
    }, (r) {
      CustomSnackBar.showSuccessSnackBar(
        context,
        'Please check your email to verify',
      );
      Navigator.pushReplacementNamed(context, Routes.signIn);
    });
  }
}
