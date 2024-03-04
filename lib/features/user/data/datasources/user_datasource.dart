import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../domain/entities/user_entity.dart';

abstract class UserDataSource {
  Future<UserEntity> getUser({
    required String uid,
  });

  Future<UserEntity> updateUser({
    required UserEntity userEntity,
  });

  Future<List<String>> getUserLikes({
    required String userUid,
  });

  Future<Unit> addUserLike({
    required String userUid,
    required String postUid,
  });

  Future<Unit> removeUserLike({
    required String userUid,
    required String postUid,
  });

  Future<Unit> deleteUser({
    required String uid,
  });

  Future<Unit> updateUserProfileImage({
    required String uid,
    XFile? profileImage,
    XFile? coverImage,
  });
}
