import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';
import 'package:pedalpulse/features/auth/domain/usecases/get_current_user_uid_usecase.dart';

import '../../../../mocks/auth/firebase/mock_firebase_auth_repository.mocks.dart';

void main() {
  late GetCurrentUserUidUseCase getUserUidUseCase;
  late MockFirebaseAuthRepository repository;

  setUp(() {
    repository = MockFirebaseAuthRepository();
    getUserUidUseCase = GetCurrentUserUidUseCase(repository: repository);
  });

  const String tUid = 'uid';
  final tUserNotFoundFailure = UserFailure(message: 'User is not found');
  final tServerFailure = UserFailure(message: 'Server failure');

  group('GetCurrentUserUidUseCase', () {
    test('should get current user uid from the repository', () async {
      // arrange
      when(repository.getCurrentUserUid())
          .thenAnswer((_) async => const Right(tUid));

      // act
      final result = await getUserUidUseCase();

      // assert
      expect(result, const Right(tUid));
      verify(repository.getCurrentUserUid()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return UserNotFoundFailure when user is not found', () async {
      // arrange
      when(repository.getCurrentUserUid())
          .thenAnswer((_) async => Left(tUserNotFoundFailure));

      // act
      final result = await getUserUidUseCase();

      // assert
      expect(result, Left(tUserNotFoundFailure));
      verify(repository.getCurrentUserUid()).called(1);
    });

    test('should return ServerFailure when server failure', () async {
      // arrange
      when(repository.getCurrentUserUid())
          .thenAnswer((_) async => Left(tServerFailure));

      // act
      final result = await getUserUidUseCase();

      // assert
      expect(result, Left(tServerFailure));
      verify(repository.getCurrentUserUid()).called(1);
    });
  });
}
