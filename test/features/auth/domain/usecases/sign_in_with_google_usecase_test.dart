import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/google_auth_failure.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_google_usecase.dart';

import '../../../../mocks/mock_social_auth_repository.mocks.dart';
import '../../../../mocks/mock_user_credential.mocks.dart';

void main() {
  late SignInWithGoogleUseCase useCase;
  late MockSocialAuthRepository repository;

  setUp(() {
    repository = MockSocialAuthRepository();
    useCase = SignInWithGoogleUseCase(repository: repository);
  });

  final UserCredential tUserCredential = MockUserCredential();

  final Failure failure = GoogleAuthFailure(message: 'Google sign in failed');

  group('SignInWithGoogleTest', () {
    test('should sign in the user and get user credential', () async {
      // Arrange
      when(repository.signInWithGoogle())
          .thenAnswer((_) async => Right(tUserCredential));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, Right(tUserCredential));
      verify(repository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when Google sign in fails', () async {
      // Arrange
      when(repository.signInWithGoogle())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, Left(failure));
      verify(repository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
