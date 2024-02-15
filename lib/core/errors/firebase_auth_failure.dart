import 'failure.dart';

class FirebaseAuthFailure extends Failure {
  final String message;

  static const String userNotFoundMessage = 'No user found for that email.';
  static const String wrongPasswordMessage =
      'Wrong password provided for that user.';
  static const String emailAlreadyInUseMessage =
      'The email address is already in use by another account.';
  static const String invalidEmailMessage =
      'The email address is badly formatted.';
  static const String userDisabledMessage =
      'The user account has been disabled by an administrator.';
  static const String userTokenExpiredMessage =
      'The user\'s credential is no longer valid. The user must sign in again.';

  static const String userNotFoundCode = 'user-not-found';
  static const String wrongPasswordCode = 'wrong-password';
  static const String emailAlreadyInUseCode = 'email-already-in-use';
  static const String invalidEmailCode = 'invalid-email';
  static const String userDisabledCode = 'user-disabled';
  static const String userTokenExpiredCode = 'user-token-expired';

  FirebaseAuthFailure({required this.message});

  @override
  String toString() => 'AuthFailure: $message';
}
