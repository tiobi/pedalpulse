import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.mapper.dart';

@MappableClass()
class UserModel extends UserEntity with UserModelMappable {
  UserModel({
    required String uid,
    required String username,
    required String email,
    required String profileImageUrl,
    required String backgroundImageUrl,
    required String bio,
    required DateTime joinedAt,
  }) : super(
          uid: uid,
          username: username,
          email: email,
          profileImage: profileImageUrl,
          coverImage: backgroundImageUrl,
          bio: bio,
          joinedAt: joinedAt,
        );

  static const fromJson = UserModelMapper.fromJson;
  static const fromMap = UserModelMapper.fromMap;
}
