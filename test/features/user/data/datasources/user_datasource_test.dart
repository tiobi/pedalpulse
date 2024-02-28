import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/features/user/data/datasources/user_datasource.dart';
import 'package:pedalpulse/features/user/data/datasources/user_datasource_impl.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity.dart';

import '../../../../mocks/database/mock_collection_reference.mocks.dart';
import '../../../../mocks/database/mock_document_refernce.mocks.dart';
import '../../../../mocks/database/mock_firebasse_firestore.mocks.dart';
import '../../../../mocks/user/mock_user_entity.mocks.dart';

void main() {
  late UserDataSource dataSource;
  late MockFirebaseFirestore firestore;
  late MockCollectionReference collection;
  late MockDocumentReference document;
  late UserEntity tUserEntity;

  setUp(() {
    firestore = MockFirebaseFirestore();
    collection = MockCollectionReference();
    document = MockDocumentReference();

    dataSource = UserDataSourceImpl(
      firestore: firestore,
    );

    tUserEntity = MockUserEntity();

    when(firestore.collection(any)).thenReturn(collection);
    when(collection.doc(any)).thenReturn(document);
    when(document.get()).thenAnswer((_) async =>
        Future.value(tUserEntity as DocumentSnapshot<Map<String, dynamic>>));
  });

  const String tUserUid = 'user-uid';
  const String tPostUid = 'post-uid';

  XFile tProfileImage = XFile('profile-image');
  XFile tCoverImage = XFile('cover-image');
  XFile? tNullProfileImage;
  XFile? tNullCoverImage;

  group('UserDataSourceImpl Test', () {
    /// Get User Test
    ///
    group('GetUser Test', () {
      test('should get the user from the datasource', () async {
        // Arrange
        when(firestore.collection('users')).thenReturn(collection);
        when(collection.doc(tUserUid)).thenReturn(document);
        when(document.get()).thenAnswer((_) async => Future.value(
            tUserEntity as DocumentSnapshot<Map<String, dynamic>>));

        // Act
        final result = await dataSource.getUser(uid: tUserUid);

        // Assert
        expect(result, tUserEntity);
      });
    });
  });
}
