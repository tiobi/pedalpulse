import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';
import 'package:pedalpulse/features/user/domain/usecases/get_user_usecase.dart';

import '../../../../mocks/user/mock_user_entity.mocks.dart';
import '../../../../mocks/user/mock_user_repository.mocks.dart';

void main() {
  late GetUserUseCase useCase;
  late MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
    useCase = GetUserUseCase(repository: repository);
  });

  const String tUid = 'uid';
  final Failure failure = UserFailure(message: 'User Failure');

  final MockUserEntity tUserEntity = MockUserEntity();

  group('GetUserUseCase Test', () {
    test('should get user ', () async {
      // Arrange
      when(repository.getUser(uid: tUid))
          .thenAnswer((_) async => Right(tUserEntity));

      // Act
      final result = await useCase(uid: tUid);

      // Assert
      expect(result, Right(tUserEntity));
      verify(repository.getUser(uid: tUid)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when getting user data fails', () async {
      // Arrange
      when(repository.getUser(uid: tUid))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(uid: tUid);

      // Assert
      expect(result, Left(failure));
      verify(repository.getUser(uid: tUid)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
