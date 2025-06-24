import 'failure.dart';

class UserFailure extends Failure {
  const UserFailure({required String message}) : super(message: message);

  static const String userNotFoundCode = 'user-not-found';
  static const String permissionDeniedCode = 'permission-denied';
  static const String networkErrorCode = 'network-error';
  static const String unknownErrorCode = 'unknown-error';

  @override
  String toString() => 'UserFailure: $message';
}
