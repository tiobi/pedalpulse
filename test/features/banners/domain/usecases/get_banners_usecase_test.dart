import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/banner_failure.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/features/banners/domain/entities/banner_entity.dart';
import 'package:pedalpulse/features/banners/domain/usecases/get_banners_usecase.dart';

import '../../../../mocks/banners/mock_banners_repository.mocks.dart';

void main() {
  late GetBannersUseCase useCase;
  late MockBannersRepository repository;

  setUp(() {
    repository = MockBannersRepository();
    useCase = GetBannersUseCase(repository: repository);
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

  group('GetBannersUseCase Test', () {
    test('should get a list of banner entity when use case is called.',
        () async {
      // Arrange
      when(repository.getBanners()).thenAnswer((_) async => Right(tBannerList));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, Right(tBannerList));
      verify(repository.getBanners()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when server fails', () async {
      // Arrange
      when(repository.getBanners())
          .thenAnswer((_) async => Left(serverFailure));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, Left(serverFailure));
      verify(repository.getBanners()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return a Failure when there is no banner in the firebase',
        () async {
      // Arrange
      when(repository.getBanners())
          .thenAnswer((_) async => Left(emptyBannerFailure));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, Left(emptyBannerFailure));
      verify(repository.getBanners()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
