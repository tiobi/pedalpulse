import 'package:dart_mappable/dart_mappable.dart';

import '../../data/models/rating_model.dart';

part 'review_entity.mapper.dart';

@MappableClass()
class ReviewEntity with ReviewEntityMappable {
  final String uid;
  final String postUid;
  final String userUid;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RatingModel? rating;
  final List<ReviewEntity> replies;
  final List<String> reportedBy;
  final int likesCount;

  ReviewEntity({
    required this.uid,
    required this.userUid,
    required this.postUid,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.replies = const [],
    this.likesCount = 0,
    this.reportedBy = const [],
    this.rating,
  });

  factory ReviewEntity.fromMap(Map<String, dynamic> map) {
    return ReviewEntity(
      uid: map['uid'],
      userUid: map['userUid'],
      postUid: map['postUid'],
      comment: map['comment'],
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      replies: List<ReviewEntity>.from(
        map['replies'].map(
          (pedal) => ReviewEntity.fromMap(pedal),
        ),
      ),
      likesCount: map['likesCount'] ?? 0,
      reportedBy: List<String>.from(map['reportedBy'] ?? []),
      rating: map['rating'] != null ? RatingModel.fromMap(map['rating']) : null,
    );
  }
}
