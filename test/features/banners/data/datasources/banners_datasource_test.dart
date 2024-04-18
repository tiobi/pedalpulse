import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/banner_failure.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/features/banners/data/datasources/banners_datasource.dart';
import 'package:pedalpulse/features/banners/data/datasources/banners_datasource_impl.dart';
import 'package:pedalpulse/features/banners/domain/entities/banner_entity.dart';

import '../../../../mocks/database/mock_collection_reference.mocks.dart';
import '../../../../mocks/database/mock_document_refernce.mocks.dart';
import '../../../../mocks/database/mock_document_snapshot.mocks.dart';
import '../../../../mocks/database/mock_firebasse_firestore.mocks.dart';
import '../../../../mocks/database/mock_query.mocks.dart';
import '../../../../mocks/database/mock_query_document_snapshot.mocks.dart';
import '../../../../mocks/database/mock_query_snapshot.mocks.dart';

void main() {
  late BannersDataSource dataSource;
  late MockFirebaseFirestore firestore;
  late MockCollectionReference collection;
  late MockDocumentReference document;
  late MockDocumentSnapshot documentSnapshot;
  late MockQuery query;
  late MockQuerySnapshot querySnapshot;
  late MockQueryDocumentSnapshot queryDocumentSnapshot;

  setUp(() {
    firestore = MockFirebaseFirestore();
    dataSource = BannersDataSourceImpl(firestore: firestore);
    collection = MockCollectionReference();

    query = MockQuery();
    querySnapshot = MockQuerySnapshot();
    queryDocumentSnapshot = MockQueryDocumentSnapshot();
    document = MockDocumentReference();
    documentSnapshot = MockDocumentSnapshot();

    when(firestore.collection(any)).thenReturn(collection);
    when(collection.orderBy(any).get()).thenAnswer((_) async => querySnapshot);
    when(document.get()).thenAnswer((_) async => documentSnapshot);
  });

  const String tUid = 'uid';
  const String tEmptyUid = '';

  final BannerEntity tBannerEntity1 = BannerEntity(
    uid: "uid",
    postUrl: "postUrl",
    imageUrl: "imageUrl",
    views: 10,
  );

  final BannerEntity tBannerEntity2 = BannerEntity(
    uid: "uid2",
    postUrl: "postUrl2",
    imageUrl: "imageUrl2",
    views: 0,
    order: '1',
  );

  final List<BannerEntity> tBannerList = [
    tBannerEntity1,
    tBannerEntity2,
  ];

  final Map<String, dynamic> tBannerMap1 = tBannerEntity1.toMap();
  final Map<String, dynamic> tBannerMap2 = tBannerEntity2.toMap();

  final Map<String, dynamic> tBannerMapList = {
    'featured': [tBannerMap1, tBannerMap2]
  };

  final Failure serverFailure = BannerFailure(message: 'Server Failure');
  final Failure emptyBannerFailure =
      BannerFailure(message: 'Empty Banner Failure');
  final Failure bannerNotFoundFailure =
      BannerFailure(message: 'Banner Not Found');

  group('BannersDataSource Test', () {
    /// Get Banners Test
    ///
    test('should get the list of Banner Entity from the datasource', () async {
      // Arrange
      when(documentSnapshot.data()).thenReturn(tBannerMapList);

      // Act
      final result = await dataSource.getBanners();

      // Assert
      expect(result, tBannerList);
    });

    test(
        'should return a ServerFailure when the call to datasource is unsuccessful',
        () async {
      // Arrange
      when(firestore.collection(any).orderBy('order').get())
          .thenThrow(Exception());

      // Act
      final result = await dataSource.getBanners();

      // Assert
      expect(result, serverFailure);
    });

    /// Increase Banner Views Test
    ///
    test('should increase the views of a banner', () async {
      // Arrange

      // Act
      final result = await dataSource.increaseBannerViews(uid: tUid);

      // Assert
      expect(result, unit);
    });

    test(
        'should return a ServerFailure when the call to datasource is unsuccessful',
        () async {
      // Arrange
      when(firestore.collection('banners')).thenReturn(collection);
      when(collection.doc(tUid)).thenReturn(document);
      when(document.update({'views': 1})).thenThrow(Exception());

      // Act
      final result = await dataSource.increaseBannerViews(uid: tUid);

      // Assert
      expect(result, serverFailure);
    });
  });
}
