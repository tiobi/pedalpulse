import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';
import 'package:pedalpulse/features/user/data/repositories/user_repository_impl.dart';
import 'package:pedalpulse/features/user/domain/repositories/user_repository.dart';

import '../../../../mocks/user/mock_user_datasource.mocks.dart';
import '../../../../mocks/user/mock_user_entity.mocks.dart';

void main() {
  late UserRepository repository;
  late MockUserDataSource dataSource;

  setUp(() {
    dataSource = MockUserDataSource();
    repository = UserRepositoryImpl(dataSource: dataSource);
  });

  const String tUserUid = 'user-uid';
  const String tPostUid = 'post-uid';
  const List<String> tUserLikes = ['post-uid-1', 'post-uid-2'];
  const List<String> tEmptyUserLikes = [];
  final MockUserEntity tUserEntity = MockUserEntity();

  final XFile tProfileImage = XFile('profile-image');
  final XFile tCoverImage = XFile('cover-image');

  const XFile? tNullProfileImage = null;
  const XFile? tNullCoverImage = null;

  final Failure noUserFailure = UserFailure(message: 'No User Found');
  final Failure serverFailure = UserFailure(message: 'Server Failure');
  final Failure noLikesFailure = UserFailure(message: 'No Likes Found');
  final Failure nullImagesFailure = UserFailure(message: 'Null Images');

  group('UserRepository Test', () {
    /// Get User Test
    ///
    group('GetUser Test', () {
      test('should get the user from the datasource', () async {
        /// Arrange
        when(dataSource.getUser(uid: tUserUid))
            .thenAnswer((_) async => tUserEntity);

        /// Act
        final result = await repository.getUser(uid: tUserUid);

        /// Assert
        expect(result, Right(tUserEntity));
        verify(dataSource.getUser(uid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the user is not found', () async {
        /// Arrange
        when(dataSource.getUser(uid: tUserUid)).thenThrow(noUserFailure);

        /// Act
        final result = await repository.getUser(uid: tUserUid);

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((noUserFailure) => noUserFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.getUser(uid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the server fails', () async {
        /// Arrange
        when(dataSource.getUser(uid: tUserUid)).thenThrow(serverFailure);

        /// Act
        final result = await repository.getUser(uid: tUserUid);

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((serverFailure) => serverFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.getUser(uid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });
    });

    /// Update User Test
    ///
    group('UpdateUser Test', () {
      test('should update the user in the datasource', () async {
        /// Arrange
        when(dataSource.updateUser(userModel: tUserEntity))
            .thenAnswer((_) async => tUserEntity);

        /// Act
        final result = await repository.updateUser(userEntity: tUserEntity);

        /// Assert
        expect(result, Right(tUserEntity));
        verify(dataSource.updateUser(userModel: tUserEntity)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when user is not found', () async {
        /// Arrange
        when(dataSource.updateUser(userModel: tUserEntity))
            .thenThrow(noUserFailure);

        /// Act
        final result = await repository.updateUser(userEntity: tUserEntity);

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((noUserFailure) => noUserFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.updateUser(userModel: tUserEntity)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the server fails', () async {
        /// Arrange
        when(dataSource.updateUser(userModel: tUserEntity))
            .thenThrow(serverFailure);

        /// Act
        final result = await repository.updateUser(userEntity: tUserEntity);

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((serverFailure) => serverFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.updateUser(userModel: tUserEntity)).called(1);
        verifyNoMoreInteractions(dataSource);
      });
    });

    /// Get User Likes Test
    ///
    group('GetUserLikes Test', () {
      test('should get the user likes from the datasource', () async {
        /// Arrange
        when(dataSource.getUserLikes(userUid: tUserUid))
            .thenAnswer((_) async => tUserLikes);

        /// Act
        final result = await repository.getUserLikes(userUid: tUserUid);

        /// Assert
        expect(result, const Right(tUserLikes));
        verify(dataSource.getUserLikes(userUid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should get an empty user likes list from the datasource', () async {
        /// Arrange
        when(dataSource.getUserLikes(userUid: tUserUid))
            .thenAnswer((_) async => tEmptyUserLikes);

        /// Act
        final result = await repository.getUserLikes(userUid: tUserUid);

        /// Assert
        expect(result, const Right(tEmptyUserLikes));
        verify(dataSource.getUserLikes(userUid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the user is not found', () async {
        /// Arrange
        when(dataSource.getUserLikes(userUid: tUserUid))
            .thenThrow(noUserFailure);

        /// Act
        final result = await repository.getUserLikes(userUid: tUserUid);

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((noUserFailure) => noUserFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.getUserLikes(userUid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the server fails', () async {
        /// Arrange
        when(dataSource.getUserLikes(userUid: tUserUid))
            .thenThrow(serverFailure);

        /// Act
        final result = await repository.getUserLikes(userUid: tUserUid);

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((serverFailure) => serverFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.getUserLikes(userUid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });
    });

    /// Add User Like Test
    ///
    group('AddUserLike Test', () {
      test('should add the user like in the datasource', () async {
        /// Arrange
        when(dataSource.addUserLike(userUid: tUserUid, postUid: tPostUid))
            .thenAnswer((_) async => unit);

        /// Act
        final result = await repository.addUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        /// Assert
        expect(result, const Right(unit));
        verify(dataSource.addUserLike(userUid: tUserUid, postUid: tPostUid))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the user is not found', () async {
        /// Arrange
        when(dataSource.addUserLike(userUid: tUserUid, postUid: tPostUid))
            .thenThrow(noUserFailure);

        /// Act
        final result = await repository.addUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((noUserFailure) => noUserFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.addUserLike(userUid: tUserUid, postUid: tPostUid))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the server fails', () async {
        /// Arrange
        when(dataSource.addUserLike(userUid: tUserUid, postUid: tPostUid))
            .thenThrow(serverFailure);

        /// Act
        final result = await repository.addUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((serverFailure) => serverFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.addUserLike(userUid: tUserUid, postUid: tPostUid))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });
    });

    /// Remove User Like Test
    ///
    group('RemoveUserLike Test', () {
      test('should remove the user like in the datasource', () async {
        /// Arrange
        when(dataSource.removeUserLike(userUid: tUserUid, postUid: tPostUid))
            .thenAnswer((_) async => unit);

        /// Act
        final result = await repository.removeUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        /// Assert
        expect(result, const Right(unit));
        verify(dataSource.removeUserLike(userUid: tUserUid, postUid: tPostUid))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when like is not found', () async {
        /// Arrange
        when(dataSource.removeUserLike(userUid: tUserUid, postUid: tPostUid))
            .thenThrow(noLikesFailure);

        /// Act
        final result = await repository.removeUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((noLikesFailure) => noLikesFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.removeUserLike(userUid: tUserUid, postUid: tPostUid))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the user is not found', () async {
        /// Arrange
        when(dataSource.removeUserLike(userUid: tUserUid, postUid: tPostUid))
            .thenThrow(noUserFailure);

        /// Act
        final result = await repository.removeUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((noUserFailure) => noUserFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.removeUserLike(userUid: tUserUid, postUid: tPostUid))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the server fails', () async {
        /// Arrange
        when(dataSource.removeUserLike(userUid: tUserUid, postUid: tPostUid))
            .thenThrow(serverFailure);

        /// Act
        final result = await repository.removeUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((serverFailure) => serverFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.removeUserLike(userUid: tUserUid, postUid: tPostUid))
            .called(1);
        verifyNoMoreInteractions(dataSource);
      });
    });

    /// Delete User Test
    ///
    group('DeleteUser Test', () {
      test('should delete the user from the datasource', () async {
        /// Arrange
        when(dataSource.deleteUser(uid: tUserUid))
            .thenAnswer((_) async => unit);

        /// Act
        final result = await repository.deleteUser(uid: tUserUid);

        /// Assert
        expect(result, const Right(unit));
        verify(dataSource.deleteUser(uid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the user is not found', () async {
        /// Arrange
        when(dataSource.deleteUser(uid: tUserUid)).thenThrow(noUserFailure);

        /// Act
        final result = await repository.deleteUser(uid: tUserUid);

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((noUserFailure) => noUserFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.deleteUser(uid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should return a Failure when the server fails', () async {
        /// Arrange
        when(dataSource.deleteUser(uid: tUserUid)).thenThrow(serverFailure);

        /// Act
        final result = await repository.deleteUser(uid: tUserUid);

        /// Assert
        expect(result.isLeft(), true);
        expect(result.fold((serverFailure) => serverFailure, (r) => r),
            isA<UserFailure>());
        verify(dataSource.deleteUser(uid: tUserUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });
    });

    /// Update User Profile Image Test
    ///
    group('UpdateUserProfileImage Test', () {
      test('should update the user profile image in the datasource', () async {
        /// Arrange
        when(dataSource.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tProfileImage,
          coverImage: tCoverImage,
        )).thenAnswer((_) async => unit);

        /// Act
        final result = await repository.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tProfileImage,
          coverImage: tCoverImage,
        );

        /// Assert
        expect(result, const Right(unit));
        verify(dataSource.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tProfileImage,
          coverImage: tCoverImage,
        )).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test(
          'should update the user profile image in the datasource with null cover image',
          () async {
        /// Arrange
        when(dataSource.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tProfileImage,
          coverImage: tNullCoverImage,
        )).thenAnswer((_) async => unit);

        /// Act
        final result = await repository.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tProfileImage,
          coverImage: tNullCoverImage,
        );

        /// Assert
        expect(result, const Right(unit));
        verify(dataSource.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tProfileImage,
          coverImage: tNullCoverImage,
        )).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test(
          'should update the user profile image in the datasource with null profile image',
          () async {
        /// Arrange
        when(dataSource.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tNullProfileImage,
          coverImage: tCoverImage,
        )).thenAnswer((_) async => unit);

        /// Act
        final result = await repository.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tNullProfileImage,
          coverImage: tCoverImage,
        );

        /// Assert
        expect(result, const Right(unit));
        verify(dataSource.updateUserProfileImage(
          uid: tUserUid,
          profileImage: tNullProfileImage,
          coverImage: tCoverImage,
        )).called(1);
        verifyNoMoreInteractions(dataSource);
      });
    });

    test('should return a Failure when both images are null', () async {
      /// Arrange
      when(dataSource.updateUserProfileImage(
        uid: tUserUid,
        profileImage: tNullProfileImage,
        coverImage: tNullCoverImage,
      )).thenThrow(nullImagesFailure);

      /// Act
      final result = await repository.updateUserProfileImage(
        uid: tUserUid,
        profileImage: tNullProfileImage,
        coverImage: tNullCoverImage,
      );

      /// Assert
      expect(result.isLeft(), true);
      expect(result.fold((failure) => failure, (r) => r), isA<UserFailure>());
    });

    test('should return a Failure when the user is not found', () async {
      /// Arrange
      when(dataSource.updateUserProfileImage(
        uid: tUserUid,
        profileImage: tProfileImage,
        coverImage: tCoverImage,
      )).thenThrow(noUserFailure);

      /// Act
      final result = await repository.updateUserProfileImage(
        uid: tUserUid,
        profileImage: tProfileImage,
        coverImage: tCoverImage,
      );

      /// Assert
      expect(result.isLeft(), true);
      expect(result.fold((noUserFailure) => noUserFailure, (r) => r),
          isA<UserFailure>());
      verify(dataSource.updateUserProfileImage(
        uid: tUserUid,
        profileImage: tProfileImage,
        coverImage: tCoverImage,
      )).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('should return a Failure when server fails', () async {
      /// Arrange
      when(dataSource.updateUserProfileImage(
        uid: tUserUid,
        profileImage: tProfileImage,
        coverImage: tCoverImage,
      )).thenThrow(serverFailure);

      /// Act
      final result = await repository.updateUserProfileImage(
        uid: tUserUid,
        profileImage: tProfileImage,
        coverImage: tCoverImage,
      );

      /// Assert
      expect(result.isLeft(), true);
      expect(result.fold((serverFailure) => serverFailure, (r) => r),
          isA<UserFailure>());
      verify(dataSource.updateUserProfileImage(
        uid: tUserUid,
        profileImage: tProfileImage,
        coverImage: tCoverImage,
      )).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
