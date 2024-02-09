import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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

  group('FirebaseAuthRepository Sign In Test', () {
    /// Sign Up With Email And Password Test
    ///
    group('SignInWithEmailAndPassword Test', () {
      test('should sign in the user and get user credential', () async {
        // Arrange
        when(dataSource.signInWithEmailAndPassword(authEntity: tAuthEntity))
            .thenAnswer((_) async => tUserCredential);

        // Act
        final result = await repository.signInWithEmailAndPassword(
            authEntity: tAuthEntity);

        // Assert
        expect(result, Right(tUserCredential));
        verify(dataSource.signInWithEmailAndPassword(authEntity: tAuthEntity))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the sign in fails', () async {
        // Arrange
        when(dataSource.signInWithEmailAndPassword(authEntity: tAuthEntity))
            .thenThrow(FirebaseAuthFailure('Server Failure'));

        // Act
        final result = await repository.signInWithEmailAndPassword(
            authEntity: tAuthEntity);

        // Assert
        expect(result, isA<Left>());
      });
    });
  });

  group('signOut Test', () {
    test('should sign out the user', () async {
      // Arrange
      when(dataSource.signOut()).thenAnswer((_) async => unit);

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, const Right(unit));
      verify(dataSource.signOut()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('should return a Failure when the sign out fails', () async {
      // Arrange
      when(dataSource.signOut())
          .thenThrow(FirebaseAuthFailure('Server Failure'));

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, equals(Left(FirebaseAuthFailure('Server Failure'))));
    });
  });
}
