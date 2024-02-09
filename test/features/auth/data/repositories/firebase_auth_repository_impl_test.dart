import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';

import '../../mocks/mock_firebase_auth_datasource.mocks.dart';
import '../../mocks/mock_user_credential.mocks.dart';

void main() {
  late FirebaseAuthRepository repository;
  late MockFirebaseAuthDataSource dataSource;

  setUp(() {
    dataSource = MockFirebaseAuthDataSource();
    repository = FirebaseAuthRepositoryImpl(dataSource: dataSource);
  });

  const String tEmail = 'hello@world.com';
  const String tPassword = 'password1234';
  const String tEmptyEmail = '';
  const String tEmptyPassword = '';

  const AuthEntity tAuthEntity = AuthEntity(
    email: tEmail,
    password: tPassword,
  );
  const AuthEntity tEmptyAuthEntity = AuthEntity(
    email: tEmptyEmail,
    password: tEmptyPassword,
  );

  final UserCredential tUserCredential = MockUserCredential();

  final Failure failure = FirebaseAuthFailure(
    'Server Failure',
  );

  group('FirebaseAuthRepository Test', () {
    /// Sign Up With Email And Password Test
    ///
    test('should sign up the user and get user credential', () async {
      // Arrange
    });
  });
}
