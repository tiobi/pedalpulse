import 'failure.dart';

class GoogleAdFailure extends Failure {
  final String message;

  GoogleAdFailure(this.message);

  @override
  String toString() => 'GoogleAdFailure: $message';
}
