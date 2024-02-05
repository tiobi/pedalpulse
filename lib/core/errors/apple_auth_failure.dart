import 'package:pedalpulse/core/errors/failure.dart';

class AppleAuthFailure extends Failure {
  final String message;

  AppleAuthFailure(this.message);

  @override
  String toString() => 'AppleAuthFailure: $message';
}
