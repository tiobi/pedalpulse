import 'failure.dart';

class FirebaseStorageFailure extends Failure {
  final String message;

  FirebaseStorageFailure({required this.message});

  @override
  String toString() => 'FirebaseStorageFailure: $message';
}
