import 'failure.dart';

class AuthFailure extends Failure {
  final String message;

  AuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}
