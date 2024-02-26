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

  Future<void> addUserLike({
    required String userUid,
    required String postUid,
  });

  Future<void> removeUserLike({
    required String userUid,
    required String postUid,
  });

  Future<void> deleteUser({
    required String uid,
  });

  Future<void> updateUserProfileImage({
    required String uid,
    XFile? profileImage,
    XFile? coverImage,
  });
}
