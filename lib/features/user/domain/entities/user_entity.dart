import 'package:dart_mappable/dart_mappable.dart';

part 'user_entity.mapper.dart';

@MappableClass()
class UserEntity with UserEntityMappable {
  final String uid;
  final String username;
  final String email;
  final String profileImage;
  final String coverImage;
  final String bio;
  final DateTime joinedAt;

  const UserEntity({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileImage,
    required this.coverImage,
    required this.bio,
    required this.joinedAt,
  });

  static const fromMap = UserEntityMapper.fromMap;
  static const fromJson = UserEntityMapper.fromJson;
}
