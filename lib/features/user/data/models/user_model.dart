import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.mapper.dart';

@MappableClass()
class UserModel with UserModelMappable {
  final String uid;
  final String username;
  final String email;
  final String profileImageUrl;
  final String backgroundImageUrl;
  final String bio;
  final DateTime joinedAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.backgroundImageUrl,
    required this.bio,
    required this.joinedAt,
  });

  static const fromJson = UserModelMapper.fromJson;
  static const fromMap = UserModelMapper.fromMap;

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      username: username,
      email: email,
      profileImageUrl: profileImageUrl,
      backgroundImageUrl: backgroundImageUrl,
      bio: bio,
      joinedAt: joinedAt,
    );
  }
}
