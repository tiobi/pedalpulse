import 'package:flutter/material.dart';
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

  AuthProvider({
    required this.isEmailVerifiedUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.signInWithEmailAndPasswordUseCase,
    required this.signOutUseCase,
    required this.signUpWithEmailAndPasswordUseCase,
  });

  Future<void> isEmailVerified({
    required String email,
  }) async {
    final result = await isEmailVerifiedUseCase(email: email);

    if (result.isRight()) {}
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await sendPasswordResetEmailUseCase(email: email);
  }

  Future<void> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    await signInWithEmailAndPasswordUseCase(authEntity: authEntity);
  }

  Future<void> signOut() async {}

  Future<void> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    await signUpWithEmailAndPasswordUseCase(authEntity: authEntity);
  }
}
