import 'package:flutter/material.dart';
import 'package:pedalpulse/features/auth/domain/usecases/is_email_verified_usecase.dart';
import 'package:pedalpulse/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';

class AuthProvider extends ChangeNotifier {
  IsEmailVerifiedUseCase isEmailVerifiedUseCase;
  SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  SignOutUseCase signOutUseCase;
  SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase;

  AuthProvider({
    required this.isEmailVerifiedUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.signInWithEmailAndPasswordUseCase,
    required this.signOutUseCase,
    required this.signUpWithEmailAndPasswordUseCase,
  });

  Future<void> isEmailVerified(String email) async {
    await isEmailVerifiedUseCase(email);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await sendPasswordResetEmailUseCase(email);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await signInWithEmailAndPasswordUseCase(email, password);
  }

  Future<void> signOut() async {
    await signOutUseCase();
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await signUpWithEmailAndPasswordUseCase(email, password);
  }
}
