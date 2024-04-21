import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUser({
    required String uid,
  });

  Future<UserModel> updateUser({
    required UserModel userModel,
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
