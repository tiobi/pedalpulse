import 'failure.dart';

class FirebaseStorageFailure extends Failure {
  FirebaseStorageFailure({required String message}) : super(message: message);

  @override
  String toString() => 'FirebaseStorageFailure: $message';
}
