import 'package:firebase_auth/firebase_auth.dart';

abstract class SocialAuthDataSource {
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithApple();
}
