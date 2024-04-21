import 'package:dart_mappable/dart_mappable.dart';

import '../../../pedals/domain/entities/pedal_entity.dart';

part 'post_entity.mapper.dart';

@MappableClass()
class PostEntity with PostEntityMappable {
  final String uid;
  final String userUid;
  final String username;
  final String userProfileImageUrl;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> imageUrls;
  final List<String> likes;
  final List<String> reports;
  final List<PedalEntity> pedalList;
  final List<String> pedalUids;
  final int likesCount;
  final int commentsCount;
  final int views;

  PostEntity({
    required this.uid,
    required this.userUid,
    required this.username,
    required this.userProfileImageUrl,
    required this.imageUrls,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.reports,
    required this.likesCount,
    required this.commentsCount,
    required this.pedalList,
    required this.pedalUids,
    required this.views,
  });

  static const fromMap = PostEntityMapper.fromMap;
  static const fromJson = PostEntityMapper.fromJson;
}
