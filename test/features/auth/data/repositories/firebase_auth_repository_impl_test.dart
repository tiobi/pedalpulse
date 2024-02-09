import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart';

import '../../mocks/mock_firebase_auth_datasource.mocks.dart';

void main() {
  late FirebaseAuthRepository repository;
  late MockFirebaseAuthDataSource dataSource;

  setUp(() {
    dataSource = MockFirebaseAuthDataSource();
    repository = FirebaseAuthRepositoryImpl(dataSource: dataSource);
  });

  final Failure failure = FirebaseAuthFailure(
    'Server Failure',
  );

  group('FirebaseAuthRepository Test', () {
    /// Sign Up
    ///
    test('should sign out the user successfully', () async {
      // Arrange
      when(dataSource.signOut()).thenAnswer((_) async => (unit));

      // Act
      final result = await repository.signOut();

      // Assert
      expect(result, const Right(unit));
      verify(dataSource.signOut());
      verifyNoMoreInteractions(dataSource);
    });
  });
}
