import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/usecases/is_email_verified_usecase.dart';

import '../../mocks/mock_firebase_auth_repository.mocks.dart';

void main() {
  late IsEmailVerifiedUseCase useCase;
  late MockFirebaseAuthRepository repository;

  setUp(() {
    repository = MockFirebaseAuthRepository();
    useCase = IsEmailVerifiedUseCase(repository: repository);
  });

  const String tEmail = 'hello@world.com';
  final Failure tFailure = FirebaseAuthFailure(
    'Server Failure',
  );

  group('IsEmailVerifiedUseCase Test', () {
    test('should return true if the email is verified', () async {
      // Arrange
      when(repository.isEmailVerified(email: tEmail))
          .thenAnswer((_) async => const Right(true));

      // Act
      final result = await useCase(tEmail);

      // Assert
      expect(result, const Right(true));
      verify(repository.isEmailVerified(email: tEmail)).called(1);
    });

    test('should return false if the email is not verified', () async {
      // Arrange
      when(repository.isEmailVerified(email: tEmail))
          .thenAnswer((_) async => const Right(false));

      // Act
      final result = await useCase(tEmail);

      // Assert
      expect(result, const Right(false));
      verify(repository.isEmailVerified(email: tEmail)).called(1);
    });

    test('should return a Failure when the email verification fails', () async {
      // Arrange
      when(repository.isEmailVerified(email: tEmail))
          .thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await useCase(tEmail);

      // Assert
      expect(result, Left(tFailure));
      verify(repository.isEmailVerified(email: tEmail)).called(1);
    });
  });
}
