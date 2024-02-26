import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';
import 'package:pedalpulse/features/user/domain/usecases/update_user_usecase.dart';

import '../../../../mocks/user/mock_user_entity.mocks.dart';
import '../../../../mocks/user/mock_user_repository.mocks.dart';

void main() {
  late UpdateUserUseCase useCase;
  late MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
    useCase = UpdateUserUseCase(repository: repository);
  });

  final Failure failure = UserFailure(message: 'User Failure');

  final MockUserEntity tUserEntity = MockUserEntity();

  group('UpdateUserUseCase Text', () {
    test('should update user data and get updated user data', () async {
      // Arrange
      when(repository.updateUser(userEntity: tUserEntity))
          .thenAnswer((_) async => Right(tUserEntity));

      // Act
      final result = await useCase(userEntity: tUserEntity);

      // Assert
      expect(result, Right(tUserEntity));
      verify(repository.updateUser(userEntity: tUserEntity)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a failure when updating user data fails', () async {
      // Arrange
      when(repository.updateUser(userEntity: tUserEntity))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(userEntity: tUserEntity);

      // Assert
      expect(result, Left(failure));
      verify(repository.updateUser(userEntity: tUserEntity)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
