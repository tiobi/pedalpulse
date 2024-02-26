import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';
import 'package:pedalpulse/features/user/domain/usecases/remove_user_like_usecase.dart';

import '../../../../mocks/user/mock_user_repository.mocks.dart';

void main() {
  late RemoveUserLikeUseCase useCase;
  late MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
    useCase = RemoveUserLikeUseCase(repository: repository);
  });

  final Failure failure = UserFailure(message: 'User Failure');

  const String tPostUid = 'post-uid';
  const String tUserUid = 'user-uid';

  group('RemoveUserLikeUseCase Test', () {
    test('should remove user like', () async {
      // Arrange
      when(repository.removeUserLike(userUid: tUserUid, postUid: tPostUid))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase(userUid: tUserUid, postUid: tPostUid);

      // Assert
      expect(result, const Right(unit));
      verify(repository.removeUserLike(userUid: tUserUid, postUid: tPostUid))
          .called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when removing user like fails', () async {
      // Arrange
      when(repository.removeUserLike(userUid: tUserUid, postUid: tPostUid))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(userUid: tUserUid, postUid: tPostUid);

      // Assert
      expect(result, Left(failure));
      verify(repository.removeUserLike(userUid: tUserUid, postUid: tPostUid))
          .called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
