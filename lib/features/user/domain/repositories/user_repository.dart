import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failure.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUser({
    required String uid,
  });

  Future<Either<Failure, UserEntity>> updateUser({
    required UserEntity userEntity,
  });

  Future<Either<Failure, List<String>>> getUserLikes({
    required String userUid,
  });

  Future<Either<Failure, Unit>> addUserLike({
    required String userUid,
    required String postUid,
  });

  Future<Either<Failure, Unit>> removeUserLike({
    required String userUid,
    required String postUid,
  });

  Future<Either<Failure, Unit>> deleteUser({
    required String uid,
  });

  Future<Either<Failure, Unit>> updateUserProfileImage({
    required String uid,
    XFile? profileImage,
    XFile? coverImage,
  });
}
