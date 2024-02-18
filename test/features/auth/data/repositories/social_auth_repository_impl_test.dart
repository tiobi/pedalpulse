import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/apple_auth_failure.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/google_auth_failure.dart';
import 'package:pedalpulse/features/auth/data/repositories/social_auth_repository_impl.dart';
import 'package:pedalpulse/features/auth/domain/repositories/social_auth_repository.dart';

import '../../../../mocks/mock_social_auth_datasource.mocks.dart';
import '../../../../mocks/mock_user_credential.mocks.dart';

void main() {
  late SocialAuthRepository repository;
  late MockSocialAuthDataSource dataSource;

  setUp(() {
    dataSource = MockSocialAuthDataSource();
    repository = SocialAuthRepositoryImpl(dataSource: dataSource);
  });

  final UserCredential tUserCredential = MockUserCredential();

  final Failure failure = GoogleAuthFailure(message: 'Google sign in failed');

  group('SocialAuthRepositoryImpl Test', () {
    group('SignInWithGoogle Test', () {
      test('should sign in the user with google', () async {
        // Arrange
        when(dataSource.signInWithGoogle())
            .thenAnswer((_) async => tUserCredential);

        // Act
        final result = await repository.signInWithGoogle();

        // Assert
        expect(result, Right(tUserCredential));
        verify(dataSource.signInWithGoogle()).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the sign in with google fails',
          () async {
        // Arrange
        when(dataSource.signInWithGoogle()).thenThrow(failure);

        // Act
        final result = await repository.signInWithGoogle();

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((failure) => failure, (r) => r),
            isA<GoogleAuthFailure>());
      });
    });

    /// Sign In With Apple Test
    ///
    group('SignInWithApple Test', () {
      test('should sign in the user with apple', () async {
        // Arrange
        when(dataSource.signInWithApple())
            .thenAnswer((_) async => tUserCredential);

        // Act
        final result = await repository.signInWithApple();

        // Assert
        expect(result, Right(tUserCredential));
        verify(dataSource.signInWithApple()).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the sign in with apple fails',
          () async {
        // Arrange
        when(dataSource.signInWithApple()).thenThrow(failure);

        // Act
        final result = await repository.signInWithApple();

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((failure) => failure, (r) => r),
            isA<AppleAuthFailure>());
      });
    });
  });
}
