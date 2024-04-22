import 'package:dart_mappable/dart_mappable.dart';

import '../../../pedals/data/models/pedal_model.dart';
import '../../domain/entities/post_entity.dart';

part 'post_model.mapper.dart';

@MappableClass()
class PostModel with PostModelMappable {
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
  final List<PedalModel> pedalList;
  final List<String> pedalUids;
  final int likesCount;
  final int commentsCount;
  final int views;

  PostModel({
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

  // static const fromMap = PostModelMapper.fromMap;
  static const fromJson = PostModelMapper.fromJson;

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'],
      userUid: map['userUid'],
      username: map['username'],
      userProfileImageUrl: map['userProfileImageUrl'],
      imageUrls: List<String>.from(map['imageUrls']),
      title: map['title'],
      description: map['description'],
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      likes: List<String>.from(map['likes']),
      reports: List<String>.from(map['reports']),
      likesCount: map['likesCount'],
      commentsCount: map['commentsCount'],
      pedalList: List<PedalModel>.from(
        map['pedalList'].map(
          (pedal) => PedalModel.fromMap(pedal),
        ),
      ),
      pedalUids: List<String>.from(map['pedalUids']),
      views: map['views'],
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      uid: uid,
      userUid: userUid,
      username: username,
      userProfileImageUrl: userProfileImageUrl,
      imageUrls: imageUrls,
      title: title,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likes: likes,
      reports: reports,
      likesCount: likesCount,
      commentsCount: commentsCount,
      pedalList: pedalList.map((e) => e.toEntity()).toList(),
      pedalUids: pedalUids,
      views: views,
    );
  }
}
