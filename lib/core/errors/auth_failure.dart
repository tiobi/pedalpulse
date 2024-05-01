import 'package:pedalpulse/core/errors/failure.dart';

class AuthFailure extends Failure {
  AuthFailure({required super.message});

  @override
  String toString() => 'Auth Failure: $message';
}
