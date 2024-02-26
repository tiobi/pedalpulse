import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';
import 'package:pedalpulse/features/user/domain/usecases/get_user_likes_usecase.dart';

import '../../../../mocks/user/mock_user_repository.mocks.dart';

void main() {
  late GetUserLikesUseCase useCase;
  late MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
    useCase = GetUserLikesUseCase(repository: repository);
  });

  const String tUserUid = 'uid';
  const List<String> tUserLikes = ['uid1', 'uid2'];

  final Failure failure = UserFailure(message: 'User Failure');

  group('GetUserLikesUseCase Test', () {
    test('should get user likes', () async {
      // Arrange
      when(repository.getUserLikes(userUid: tUserUid))
          .thenAnswer((_) async => const Right(tUserLikes));

      // Act
      final result = await useCase(userUid: tUserUid);

      // Assert
      expect(result, const Right(tUserLikes));
      verify(repository.getUserLikes(userUid: tUserUid)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when getting user likes fails', () async {
      // Arrange
      when(repository.getUserLikes(userUid: tUserUid))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(userUid: tUserUid);

      // Assert
      expect(result, Left(failure));
      verify(repository.getUserLikes(userUid: tUserUid)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
