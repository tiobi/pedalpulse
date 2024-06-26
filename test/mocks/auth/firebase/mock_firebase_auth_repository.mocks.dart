// Mocks generated by Mockito 5.4.2 from annotations
// in pedalpulse/test/mocks/auth/firebase/mock_firebase_auth_repository.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:pedalpulse/core/errors/failure.dart' as _i5;
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart'
    as _i7;
import 'package:pedalpulse/features/auth/domain/repositories/firebase_auth_repository.dart'
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

/// A class which mocks [FirebaseAuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseAuthRepository extends _i1.Mock
    implements _i3.FirebaseAuthRepository {
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.UserCredential>>
      signInWithEmailAndPassword({required _i7.AuthEntity? authEntity}) =>
          (super.noSuchMethod(
            Invocation.method(
              #signInWithEmailAndPassword,
              [],
              {#authEntity: authEntity},
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.Failure, _i6.UserCredential>>.value(
                    _FakeEither_0<_i5.Failure, _i6.UserCredential>(
              this,
              Invocation.method(
                #signInWithEmailAndPassword,
                [],
                {#authEntity: authEntity},
              ),
            )),
            returnValueForMissingStub:
                _i4.Future<_i2.Either<_i5.Failure, _i6.UserCredential>>.value(
                    _FakeEither_0<_i5.Failure, _i6.UserCredential>(
              this,
              Invocation.method(
                #signInWithEmailAndPassword,
                [],
                {#authEntity: authEntity},
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, _i6.UserCredential>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.UserCredential>>
      signUpWithEmailAndPassword({required _i7.AuthEntity? authEntity}) =>
          (super.noSuchMethod(
            Invocation.method(
              #signUpWithEmailAndPassword,
              [],
              {#authEntity: authEntity},
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.Failure, _i6.UserCredential>>.value(
                    _FakeEither_0<_i5.Failure, _i6.UserCredential>(
              this,
              Invocation.method(
                #signUpWithEmailAndPassword,
                [],
                {#authEntity: authEntity},
              ),
            )),
            returnValueForMissingStub:
                _i4.Future<_i2.Either<_i5.Failure, _i6.UserCredential>>.value(
                    _FakeEither_0<_i5.Failure, _i6.UserCredential>(
              this,
              Invocation.method(
                #signUpWithEmailAndPassword,
                [],
                {#authEntity: authEntity},
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, _i6.UserCredential>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> sendPasswordResetEmail(
          {required String? email}) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendPasswordResetEmail,
          [],
          {#email: email},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #sendPasswordResetEmail,
            [],
            {#email: email},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #sendPasswordResetEmail,
            [],
            {#email: email},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> signOut() =>
      (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #signOut,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #signOut,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> isEmailVerified(
          {required String? email}) =>
      (super.noSuchMethod(
        Invocation.method(
          #isEmailVerified,
          [],
          {#email: email},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
            _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #isEmailVerified,
            [],
            {#email: email},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
                _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #isEmailVerified,
            [],
            {#email: email},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, bool>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> getCurrentUserUid() =>
      (super.noSuchMethod(
        Invocation.method(
          #getCurrentUserUid,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, String>>.value(
            _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #getCurrentUserUid,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, String>>.value(
                _FakeEither_0<_i5.Failure, String>(
          this,
          Invocation.method(
            #getCurrentUserUid,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, String>>);
}
