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
      final result = repository.getBanners();

      // Assert
      expect(result, Right(tBannerList));
    });
  });
}
