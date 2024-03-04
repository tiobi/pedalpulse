// Mocks generated by Mockito 5.4.2 from annotations
// in pedalpulse/test/mocks/user/mock_user_repository.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:image_picker/image_picker.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:pedalpulse/core/errors/failure.dart' as _i5;
import 'package:pedalpulse/features/user/domain/entities/user_entity.dart'
    as _i6;
import 'package:pedalpulse/features/user/domain/repositories/user_repository.dart'
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

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i3.UserRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>> getUser(
          {required String? uid}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [],
          {#uid: uid},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.UserEntity>(
          this,
          Invocation.method(
            #getUser,
            [],
            {#uid: uid},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.UserEntity>(
          this,
          Invocation.method(
            #getUser,
            [],
            {#uid: uid},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>> updateUser(
          {required _i6.UserEntity? userEntity}) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUser,
          [],
          {#userEntity: userEntity},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.UserEntity>(
          this,
          Invocation.method(
            #updateUser,
            [],
            {#userEntity: userEntity},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>.value(
                _FakeEither_0<_i5.Failure, _i6.UserEntity>(
          this,
          Invocation.method(
            #updateUser,
            [],
            {#userEntity: userEntity},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.UserEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<String>>> getUserLikes(
          {required String? userUid}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserLikes,
          [],
          {#userUid: userUid},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, List<String>>>.value(
            _FakeEither_0<_i5.Failure, List<String>>(
          this,
          Invocation.method(
            #getUserLikes,
            [],
            {#userUid: userUid},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<String>>>.value(
                _FakeEither_0<_i5.Failure, List<String>>(
          this,
          Invocation.method(
            #getUserLikes,
            [],
            {#userUid: userUid},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<String>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> addUserLike({
    required String? userUid,
    required String? postUid,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addUserLike,
          [],
          {
            #userUid: userUid,
            #postUid: postUid,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #addUserLike,
            [],
            {
              #userUid: userUid,
              #postUid: postUid,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #addUserLike,
            [],
            {
              #userUid: userUid,
              #postUid: postUid,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> removeUserLike({
    required String? userUid,
    required String? postUid,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeUserLike,
          [],
          {
            #userUid: userUid,
            #postUid: postUid,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #removeUserLike,
            [],
            {
              #userUid: userUid,
              #postUid: postUid,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #removeUserLike,
            [],
            {
              #userUid: userUid,
              #postUid: postUid,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> deleteUser(
          {required String? uid}) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteUser,
          [],
          {#uid: uid},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #deleteUser,
            [],
            {#uid: uid},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #deleteUser,
            [],
            {#uid: uid},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> updateUserProfileImage({
    required String? uid,
    _i7.XFile? profileImage,
    _i7.XFile? coverImage,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserProfileImage,
          [],
          {
            #uid: uid,
            #profileImage: profileImage,
            #coverImage: coverImage,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateUserProfileImage,
            [],
            {
              #uid: uid,
              #profileImage: profileImage,
              #coverImage: coverImage,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateUserProfileImage,
            [],
            {
              #uid: uid,
              #profileImage: profileImage,
              #coverImage: coverImage,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);
}