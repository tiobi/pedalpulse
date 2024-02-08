import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/usecases/send_password_reset_email_usecase.dart';

import '../../mocks/mock_firebase_auth_repository.mocks.dart';

void main() {
  late SendPasswordResetEmailUseCase useCase;
  late MockFirebaseAuthRepository repository;

  setUp(() {
    repository = MockFirebaseAuthRepository();
    useCase = SendPasswordResetEmailUseCase(repository: repository);
  });

  const String tEmail = 'hello@world.com';

  group('SendPasswordResetEmailUseCase Test', () {
    test('should send a password reset email', () async {
      // Arrange
      when(repository.sendPasswordResetEmail(
        email: tEmail,
      )).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase(tEmail);

      // Assert
      expect(result, const Right(unit));
    });

    test('should return a Failure when the password reset email fails',
        () async {
      // Arrange
      final Failure failure = FirebaseAuthFailure(
        'Server Failure',
      );
      when(repository.sendPasswordResetEmail(
        email: tEmail,
      )).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(tEmail);

      // Assert
      expect(result, Left(failure));
    });
  });
}
