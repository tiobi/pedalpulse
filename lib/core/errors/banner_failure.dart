import 'failure.dart';

class BannerFailure extends Failure {
  BannerFailure({required String message}) : super(message: message);

  @override
  String toString() => 'Banner Failure: $message';
}
