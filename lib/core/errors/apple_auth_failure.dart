import 'package:pedalpulse/core/errors/failure.dart';

class AppleAuthFailure extends Failure {
  AppleAuthFailure({required String message}) : super(message: message);

  @override
  String toString() => 'AppleAuthFailure: $message';
}
