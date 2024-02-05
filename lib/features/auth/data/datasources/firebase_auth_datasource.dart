abstract class FirebaseAuthDataSource {
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signOut();

  Future<bool> isEmailVerified({
    required String email,
  });
}
