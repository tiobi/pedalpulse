import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/apple_auth_failure.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/features/auth/domain/usecases/sign_in_with_apple_usecase.dart';

import '../../../../mocks/auth/mock_user_credential.mocks.dart';
import '../../../../mocks/auth/social/mock_social_auth_repository.mocks.dart';

void main() {
  late SignInWithAppleUseCase useCase;
  late MockSocialAuthRepository repository;

  setUp(() {
    repository = MockSocialAuthRepository();
    useCase = SignInWithAppleUseCase(repository: repository);
  });

  final UserCredential tUserCredential = MockUserCredential();

  final Failure failure = AppleAuthFailure(message: 'Apple sign in failed');

  group('SignInWithAppleTest', () {
    test('should sign in the user and get user credential', () async {
      // Arrange
      when(repository.signInWithApple())
          .thenAnswer((_) async => Right(tUserCredential));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, Right(tUserCredential));
      verify(repository.signInWithApple()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when Apple sign in fails', () async {
      // Arrange
      when(repository.signInWithApple()).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, Left(failure));
      verify(repository.signInWithApple()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
