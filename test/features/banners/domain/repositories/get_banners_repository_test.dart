import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/banner_failure.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/features/banners/data/repositories/banners_repository_impl.dart';
import 'package:pedalpulse/features/banners/domain/entities/banners_entity.dart';
import 'package:pedalpulse/features/banners/domain/repositories/banners_repository.dart';

import '../../../../mocks/banners/mock_banners_datasource.mocks.dart';

void main() {
  late BannersRepository repository;
  late MockBannersDataSource dataSource;

  setUp(() {
    dataSource = MockBannersDataSource();
    repository = BannersRepositoryImpl(dataSource: dataSource);
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

  final Failure serverFailure = BannerFailure(message: 'Server Failure');
  final Failure emptyBannerFailure =
      BannerFailure(message: 'Empty Banner Failure');
  final Failure bannerNotFoundFailure =
      BannerFailure(message: 'Banner Not Found');

  group('BannersRepository Test', () {
    /// Get Banners Test
    ///
    test('should get the list of Banner Entity from the datasource', () async {
      // Arrange
      when(dataSource.getBanners()).thenAnswer((_) async => tBannerList);

      // Act
      final result = await repository.getBanners();

      // Assert
      expect(result, Right(tBannerList));
      verify(dataSource.getBanners()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('should get a Failure when server fails', () async {
      // Arrange
      when(dataSource.getBanners()).thenThrow(serverFailure);

      // Act
      final result = await repository.getBanners();

      // Assert
      expect(result.isLeft(), true);
      expect(result.fold((serverFailure) => serverFailure, (r) => r),
          isA<BannerFailure>());
      verify(dataSource.getBanners()).called(1);
      verifyNoMoreInteractions(dataSource);
    });
    test('should get a Failure when there is no banner to call', () async {
      // Arrange
      when(dataSource.getBanners()).thenThrow(emptyBannerFailure);

      // Act
      final result = await repository.getBanners();

      // Assert
      expect(result.isLeft(), true);
      expect(result.fold((emptyBannerFailure) => emptyBannerFailure, (r) => r),
          isA<BannerFailure>());
      verify(dataSource.getBanners()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    /// Increase Banner Views Test
    ///
    group('IncreaseBannerViews Test', () {
      test('should get a unit when banner view is increased', () async {
        // Arrange
        when(dataSource.increaseBannerViews(uid: tUid))
            .thenAnswer((_) async => unit);

        // Act
        final result = await repository.increaseBannerViews(uid: tUid);

        // Assert
        expect(result, const Right(unit));
        verify(dataSource.increaseBannerViews(uid: tUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should get a Failure when server fails', () async {
        // Arrange
        when(dataSource.increaseBannerViews(uid: tUid))
            .thenThrow(serverFailure);

        // Act
        final result = await repository.increaseBannerViews(uid: tUid);

        // Assert
        expect(result.isLeft(), true);
        expect(result.fold((serverFailure) => serverFailure, (r) => r),
            isA<BannerFailure>());
        verify(dataSource.increaseBannerViews(uid: tUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });

      test('should get a Failure when there is banner is not found', () async {
        // Arrange
        when(dataSource.increaseBannerViews(uid: tEmptyUid))
            .thenThrow(bannerNotFoundFailure);

        // Act
        final result = await repository.increaseBannerViews(uid: tEmptyUid);

        // Assert
        expect(result.isLeft(), true);
        expect(
            result.fold(
                (bannerNotFoundFailure) => bannerNotFoundFailure, (r) => r),
            isA<BannerFailure>());
        verify(dataSource.increaseBannerViews(uid: tEmptyUid)).called(1);
        verifyNoMoreInteractions(dataSource);
      });
    });
  });
}
