import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedalpulse/features/auth/data/datasources/social_auth_datasource.dart';

class SocialAuthDataSourceImpl implements SocialAuthDataSource {
  @override
  Future<UserCredential> signInWithApple() async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    throw UnimplementedError();
  }
}
