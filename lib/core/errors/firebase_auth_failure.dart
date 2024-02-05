import 'failure.dart';

class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);

  @override
  String toString() => 'AuthFailure: $message';
}
