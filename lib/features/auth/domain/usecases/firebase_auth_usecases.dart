import '../../data/datasources/firebase_auth_datasource.dart';

class FirebaseAuthUseCaseParams {
  final String email;
  final String password;

  FirebaseAuthUseCaseParams({
    required this.email,
    required this.password,
  });
}

class FirebaseAuthUseCase {
  final FirebaseAuthDataSource dataSource;

  FirebaseAuthUseCase({
    required this.dataSource,
  });

  Future<String> signInWithEmailAndPassword(
      FirebaseAuthUseCaseParams params) async {
    return await dataSource.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}
