import 'failure.dart';

class GoogleAuthFailure extends Failure {
  GoogleAuthFailure({required String message}) : super(message: message);

  @override
  String toString() => 'GoogleAuthFailure: $message';
}
