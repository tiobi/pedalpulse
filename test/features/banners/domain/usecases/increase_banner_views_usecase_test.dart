import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pedalpulse/core/errors/banner_failure.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/features/banners/domain/usecases/increase_banner_views_usecase.dart';

import '../../../../mocks/banners/mock_banners_repository.mocks.dart';

void main() {
  late IncreaseBannerViewsUseCase useCase;
  late MockBannersRepository repository;

  setUp(() {
    repository = MockBannersRepository();
    useCase = IncreaseBannerViewsUseCase(repository: repository);
  });

  const String tUid = 'uid';
  const String tEmptyUid = '';

  final Failure serverFailure = BannerFailure(message: 'Server Failure');
  final Failure bannerNotFoundFailure =
      BannerFailure(message: 'Banner Not Found');

  group('IncreaseBannerViewsUseCase Test', () {
    test('should get unit when increase views is successful', () async {
      // Arrange
      when(repository.increaseBannerViews(uid: tUid))
          .thenAnswer((realInvocation) async => const Right(unit));

      // Act
      final result = await useCase.call(uid: tUid);

      // Assert
      expect(result, const Right(unit));
      verify(repository.increaseBannerViews(uid: tUid)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should get a Failure when server fails', () async {
      // Arrange
      when(repository.increaseBannerViews(uid: tUid))
          .thenAnswer((realInvocation) async => Left(serverFailure));

      // Act
      final result = await useCase.call(uid: tUid);

      // Assert
      expect(result, Left(serverFailure));
      verify(repository.increaseBannerViews(uid: tUid)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should get a Failure when Banner is not found', () async {
      // Arrange
      when(repository.increaseBannerViews(uid: tEmptyUid))
          .thenAnswer((realInvocation) async => Left(bannerNotFoundFailure));

      // Act
      final result = await useCase.call(uid: tEmptyUid);

      // Assert
      expect(result, Left(bannerNotFoundFailure));
      verify(repository.increaseBannerViews(uid: tEmptyUid)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
