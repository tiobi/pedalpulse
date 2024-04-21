import 'failure.dart';

class FirestoreFailure extends Failure {
  FirestoreFailure({required String message}) : super(message: message);

  @override
  String toString() => 'FirestoreFailure: $message';
}
