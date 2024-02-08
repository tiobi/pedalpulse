import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';

import '../../mocks/auth_test_helpers.dart';

void main() {
  late FirebaseAuthRepository repository;
  late MockFirebaseAuthDataSource dataSource;

  setUp(() {
    dataSource = MockFirebaseAuthDataSource();
    repository = FirebaseAuthRepositoryImpl(dataSource: dataSource);
  });

  group('FirebaseAuthRepository Test', () {});
}
