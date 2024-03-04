import 'failure.dart';

class GoogleAdFailure extends Failure {
  GoogleAdFailure({required String message}) : super(message: message);

  @override
  String toString() => 'GoogleAdFailure: $message';
}
