import 'failure.dart';

class GoogleAuthFailure extends Failure {
  final String message;

  GoogleAuthFailure(this.message);

  @override
  String toString() => 'GoogleAuthFailure: $message';
}
