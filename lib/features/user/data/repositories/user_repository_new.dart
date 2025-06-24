import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/user_failure.dart';
import '../datasources/user_datasource_new.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryNew implements UserRepository {
  final UserDataSourceNew _dataSource;

  UserRepositoryNew({
    required UserDataSourceNew dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Either<Failure, UserEntity>> getUser({
    required String uid,
  }) async {
    try {
      final userModel = await _dataSource.getUser(uid: uid);
      return Right(userModel.toEntity());
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser({
    required UserEntity userEntity,
  }) async {
    try {
      final userModel = await _dataSource.updateUser(
        userModel: userEntity.toModel(),
      );
      return Right(userModel.toEntity());
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUserLikes({
    required String userUid,
  }) async {
    try {
      final likes = await _dataSource.getUserLikes(userUid: userUid);
      return Right(likes);
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addUserLike({
    required String userUid,
    required String postUid,
  }) async {
    try {
      await _dataSource.addUserLike(userUid: userUid, postUid: postUid);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeUserLike({
    required String userUid,
    required String postUid,
  }) async {
    try {
      await _dataSource.removeUserLike(userUid: userUid, postUid: postUid);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser({
    required String uid,
  }) async {
    try {
      await _dataSource.deleteUser(uid: uid);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserProfileImage({
    required String uid,
    XFile? profileImage,
    XFile? coverImage,
  }) async {
    try {
      String? profileImageUrl;
      String? coverImageUrl;

      if (profileImage != null) {
        profileImageUrl = await _dataSource.updateUserProfileImage(
          uid: uid,
          profileImage: profileImage,
        );
      }

      if (coverImage != null) {
        coverImageUrl = await _dataSource.updateUserCoverImage(
          uid: uid,
          coverImage: coverImage,
        );
      }

      final currentUser = await _dataSource.getUser(uid: uid);
      final updatedUser = currentUser.copyWith(
        profileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
        backgroundImageUrl: coverImageUrl ?? currentUser.backgroundImageUrl,
      );

      await _dataSource.updateUser(userModel: updatedUser);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> updateProfileImageOnly({
    required String uid,
    required XFile profileImage,
  }) async {
    try {
      final imageUrl = await _dataSource.updateUserProfileImage(
        uid: uid,
        profileImage: profileImage,
      );
      return Right(imageUrl);
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> updateCoverImageOnly({
    required String uid,
    required XFile coverImage,
  }) async {
    try {
      final imageUrl = await _dataSource.updateUserCoverImage(
        uid: uid,
        coverImage: coverImage,
      );
      return Right(imageUrl);
    } on FirebaseException catch (e) {
      return Left(UserFailure(message: e.message ?? e.code));
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  Stream<Either<Failure, UserEntity>> getUserStream({
    required String uid,
  }) {
    try {
      return _dataSource.getUserStream(uid: uid).map((userModel) {
        return Right(userModel.toEntity());
      }).handleError((error) {
        if (error is FirebaseException) {
          return Left(UserFailure(message: error.message ?? error.code));
        }
        return Left(UserFailure(message: error.toString()));
      });
    } catch (e) {
      return Stream.value(Left(UserFailure(message: e.toString())));
    }
  }
}