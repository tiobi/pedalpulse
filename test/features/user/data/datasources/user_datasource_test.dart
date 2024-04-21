import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';
import 'package:pedalpulse/features/user/data/datasources/user_datasource.dart';
import 'package:pedalpulse/features/user/data/datasources/user_datasource_impl.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity.dart';

import '../../../../mocks/database/mock_collection_reference.mocks.dart';
import '../../../../mocks/database/mock_document_refernce.mocks.dart';
import '../../../../mocks/database/mock_document_snapshot.mocks.dart';
import '../../../../mocks/database/mock_firebasse_firestore.mocks.dart';

void main() {
  late UserDataSource dataSource;
  late MockFirebaseFirestore firestore;
  late MockCollectionReference collection;
  late MockDocumentReference document;
  late MockDocumentSnapshot snapshot;

  setUp(() {
    firestore = MockFirebaseFirestore();
    collection = MockCollectionReference();
    document = MockDocumentReference();
    snapshot = MockDocumentSnapshot();

    dataSource = UserDataSourceImpl(
      firestore: firestore,
    );

    when(firestore.collection(any)).thenReturn(collection);
    when(collection.doc(any)).thenReturn(document);
    when(document.get()).thenAnswer((_) async => snapshot);
  });

  const String tUserUid = 'user-uid';
  const String tPostUid = 'post-uid';

  XFile tProfileImage = XFile('profile-image');
  XFile tCoverImage = XFile('cover-image');
  XFile? tNullProfileImage;
  XFile? tNullCoverImage;

  final DateTime joinedAtFixed = DateTime(2023, 12, 31);

  final UserEntity tUserEntity = UserEntity(
    uid: 'user-uid',
    email: 'user-email',
    username: 'user-username',
    profileImageUrl: 'user-profile-image',
    backgroundImageUrl: 'user-cover-image',
    bio: 'user-bio',
    joinedAt: joinedAtFixed,
  );

  final UserEntity tUpdatedUserEntity = UserEntity(
    uid: 'user-uid',
    email: 'user-email',
    username: 'user-username',
    profileImageUrl: 'user-profile-image',
    backgroundImageUrl: 'user-cover-image',
    bio: 'user-bio',
    joinedAt: joinedAtFixed,
  );

  final Map<String, dynamic> tUserMap1 = {
    'uid': 'user-uid',
    'email': 'user-email',
    'username': 'user-username',
    'profileImageUrl': 'user-profile-image',
    'backgroundImageUrl': 'user-cover-image',
    'bio': 'user-bio',
    'joinedAt': joinedAtFixed,
  };

  final List<String> tUserLikes = ['post-uid1', 'post-uid2', 'post-uid3'];
  final Map<String, dynamic> tUserLikesMap = {'likes': tUserLikes};

  final Failure serverFailure = UserFailure(message: 'Server Failure');
  final Failure userNotFoundFailure = UserFailure(message: 'User Not Found');

  group('UserDataSourceImpl Test', () {
    /// Get User Test
    ///
    group('GetUser Test', () {
      test('should get the user from the datasource', () async {
        // Arrange
        when(snapshot.data()).thenReturn(tUserMap1);

        // Act
        final result = await dataSource.getUser(uid: tUserUid);

        // Assert
        expect(result, tUserEntity);
        verify(firestore.collection('users')).called(1);
        verifyNoMoreInteractions(firestore);
      });

      test(
          'should throw a FirebaseException when the call to Firestore is unsuccessful',
          () async {
        // Arrange
        when(firestore.collection('users')).thenReturn(collection);
        when(collection.doc(tUserUid)).thenReturn(document);
        when(document.get()).thenThrow(serverFailure);

        // Act
        final result = dataSource.getUser(uid: tUserUid);

        // Assert
        expect(result, throwsA(serverFailure));
      });

      test('should throw a UserNotFoundFailure when the user is not found',
          () async {
        // Arrange
        when(firestore.collection('users')).thenReturn(collection);
        when(collection.doc(tUserUid)).thenReturn(document);
        when(document.get()).thenThrow(userNotFoundFailure);

        // Act
        final result = dataSource.getUser(uid: tUserUid);

        // Assert
        expect(result, throwsA(userNotFoundFailure));
      });
    });

    /// Update User Test
    ///
    group('UpdateUser Test', () {
      test('should update the user in the datasource', () async {
        // Arrange
        when(document.update(any)).thenAnswer((_) async => tUserEntity);

        // Act
        final result =
            await dataSource.updateUser(userModel: tUpdatedUserEntity);

        // Assert
        expect(result, tUserEntity);
        verify(document.update(any)).called(1);
        verifyNoMoreInteractions(document);
      });

      test(
          'should throw a FirebaseException when the call to Firestore is unsuccessful',
          () async {
        // Arrange
        when(document.update(any)).thenThrow(serverFailure);

        // Act
        final result = dataSource.updateUser(userModel: tUserEntity);

        // Assert
        expect(result, throwsA(serverFailure));
      });

      test('should throw a UserNotFoundFailure when the user is not found',
          () async {
        // Arrange
        when(document.update(any)).thenThrow(userNotFoundFailure);

        // Act
        final result = dataSource.updateUser(userModel: tUserEntity);

        // Assert
        expect(result, throwsA(userNotFoundFailure));
      });
    });

    /// Get User Likes Test
    ///
    group('GetUserLikes Test', () {
      test('should get the user likes from the datasource', () async {
        // Arrange
        when(snapshot.data()).thenReturn(tUserLikesMap);

        // Act
        final result = await dataSource.getUserLikes(userUid: tUserUid);

        // Assert
        expect(result, tUserEntity);
        verify(firestore.collection('users')).called(1);
        verifyNoMoreInteractions(firestore);
      });
    });

    /// RemoveUserLike Test
    ///
    group('RemoveUserLike Test', () {
      test('should remove the user like from the datasource', () async {
        // Arrange
        when(firestore.collection('users')).thenReturn(collection);
        when(collection.doc(tUserUid)).thenReturn(document);
        when(document.collection('likes')).thenReturn(collection);
        when(collection.doc(any)).thenReturn(document);
        when(document.delete()).thenAnswer((_) async => unit);

        // Act
        final result = await dataSource.removeUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        // Assert
        expect(result, unit);
        verify(document.delete()).called(1);
        verifyNoMoreInteractions(document);
      });

      test(
          'should throw a FirebaseException when the call to Firestore is unsuccessful',
          () async {
        // Arrange
        when(document.delete()).thenThrow(serverFailure);

        // Act
        final result = dataSource.removeUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        // Assert
        expect(result, throwsA(serverFailure));
      });

      test('should throw a UserNotFoundFailure when the user is not found',
          () async {
        // Arrange
        when(document.delete()).thenThrow(userNotFoundFailure);

        // Act
        final result = dataSource.removeUserLike(
          userUid: tUserUid,
          postUid: tPostUid,
        );

        // Assert
        expect(result, throwsA(userNotFoundFailure));
      });
    });

    /// DeleteUser Test
    ///
    group('DeleteUser Test', () {
      test('should delete the user from the datasource', () async {
        // Arrange
        when(document.delete()).thenAnswer((_) async => unit);

        // Act
        final result = await dataSource.deleteUser(uid: tUserUid);

        // Assert
        expect(result, unit);
        verify(document.delete()).called(1);
        verifyNoMoreInteractions(document);
      });

      test(
          'should throw a FirebaseException when the call to Firestore is unsuccessful',
          () async {
        // Arrange
        when(document.delete()).thenThrow(serverFailure);

        // Act
        final result = dataSource.deleteUser(uid: tUserUid);

        // Assert
        expect(result, throwsA(serverFailure));
      });

      test('should throw a UserNotFoundFailure when the user is not found',
          () async {
        // Arrange
        when(document.delete()).thenThrow(userNotFoundFailure);

        // Act
        final result = dataSource.deleteUser(uid: tUserUid);

        // Assert
        expect(result, throwsA(userNotFoundFailure));
      });
    });

    /// UpdateUserProfileImage Test
    ///
  });
}
