import 'failure.dart';

class FirebaseAuthFailure extends Failure {
  final String message;

  FirebaseAuthFailure(this.message);

  @override
  String toString() => 'AuthFailure: $message';
}
