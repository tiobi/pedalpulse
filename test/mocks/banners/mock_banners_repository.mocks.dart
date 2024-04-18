// Mocks generated by Mockito 5.4.2 from annotations
// in pedalpulse/test/mocks/banners/mock_banners_repository.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:pedalpulse/core/errors/failure.dart' as _i5;
import 'package:pedalpulse/features/banners/domain/entities/banner_entity.dart'
    as _i6;
import 'package:pedalpulse/features/banners/domain/repositories/banners_repository.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BannersRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockBannersRepository extends _i1.Mock implements _i3.BannersRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.BannerEntity>>> getBanners() =>
      (super.noSuchMethod(
        Invocation.method(
          #getBanners,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.BannerEntity>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.BannerEntity>>(
          this,
          Invocation.method(
            #getBanners,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.BannerEntity>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.BannerEntity>>(
          this,
          Invocation.method(
            #getBanners,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.BannerEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> increaseBannerViews(
          {required String? uid}) =>
      (super.noSuchMethod(
        Invocation.method(
          #increaseBannerViews,
          [],
          {#uid: uid},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #increaseBannerViews,
            [],
            {#uid: uid},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #increaseBannerViews,
            [],
            {#uid: uid},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);
}
