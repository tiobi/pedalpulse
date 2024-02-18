import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firebase_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';

import '../../../../mocks/auth/firebase/mock_firebase_auth_repository.mocks.dart';
import '../../../../mocks/auth/mock_user_credential.mocks.dart';

void main() {
  late SignUpWithEmailAndPasswordUseCase useCase;
  late MockFirebaseAuthRepository repository;

  setUp(() {
    repository = MockFirebaseAuthRepository();
    useCase = SignUpWithEmailAndPasswordUseCase(repository: repository);
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
    message: 'Email and password cannot be empty',
  );

  group('SignUpWithEmailAndPasswordUseCase Test', () {
    test('should sign up the user and get user credential', () async {
      // Arrange
      when(repository.signUpWithEmailAndPassword(authEntity: tAuthEntity))
          .thenAnswer((_) async => Right(tUserCredential));

      // Act
      final result = await useCase(authEntity: tAuthEntity);

      // Assert
      expect(result, Right(tUserCredential));
    });

    test('should return failure when empty email and password is provided',
        () async {
      // Arrange
      when(repository.signUpWithEmailAndPassword(authEntity: tEmptyAuthEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(authEntity: tEmptyAuthEntity);

      // Assert
      expect(result, Left(failure));
    });

    test('should return failure when sign up fails', () async {
      // Arrange
      when(repository.signUpWithEmailAndPassword(authEntity: tAuthEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(authEntity: tAuthEntity);

      // Assert
      expect(result, Left(failure));
    });
  });
}
