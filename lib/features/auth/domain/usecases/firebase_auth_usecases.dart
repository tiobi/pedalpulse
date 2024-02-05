import '../../data/datasources/firebase_auth_datasource.dart';
import '../entities/auth_entity.dart';

class FirebaseAuthUseCase {
  final FirebaseAuthDataSource dataSource;

  FirebaseAuthUseCase({
    required this.dataSource,
  });

  Future<String> signInWithEmailAndPassword(AuthEntity authEntity) async {
    return await dataSource.signInWithEmailAndPassword(
      email: authEntity.email,
      password: authEntity.password,
    );
  }
}
