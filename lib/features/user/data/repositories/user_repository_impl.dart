import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pedalpulse/features/user/domain/repositories/user_repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/user_failure.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/user_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getUser({
    required String uid,
  }) async {
    try {
      final UserModel userModel = await dataSource.getUser(uid: uid);
      final UserEntity user = userModel.toEntity();

      return Right(user);
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser({
    required UserEntity userEntity,
  }) async {
    try {
      final UserModel userModel =
          await dataSource.updateUser(userModel: userEntity.toModel());

      return Right(userModel.toEntity());
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser({
    required String uid,
  }) async {
    try {
      await dataSource.deleteUser(uid: uid);
      return const Right(unit);
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUserLikes({
    required String userUid,
  }) async {
    try {
      final likes = await dataSource.getUserLikes(userUid: userUid);
      return Right(likes);
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
      await dataSource.addUserLike(userUid: userUid, postUid: postUid);
      return const Right(unit);
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
      await dataSource.removeUserLike(userUid: userUid, postUid: postUid);
      return const Right(unit);
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
      await dataSource.updateUserProfileImage(
        uid: uid,
        profileImage: profileImage,
        coverImage: coverImage,
      );
      return const Right(unit);
    } catch (e) {
      return Left(UserFailure(message: e.toString()));
    }
  }
}
