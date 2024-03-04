import 'failure.dart';

class UserFailure extends Failure {
  UserFailure({required String message}) : super(message: message);

  @override
  String toString() => 'UserFailure: $message';
}
