import 'failure.dart';

class GoogleAuthFailure extends Failure {
  final String message;

  GoogleAuthFailure({required this.message});

  @override
  String toString() => 'GoogleAuthFailure: $message';
}
