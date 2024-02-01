import 'package:pedalpulse/models/rating_model.dart';

class CommentModel {
  final String uid;
  final String postUid;
  final String userUid;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RatingModel? rating;
  final List<CommentModel> replies;
  final List<String> reportedBy;
  final int likesCount;

  CommentModel({
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

  // Convert a Map<String, dynamic> to CommentModel
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      uid: map['uid'],
      userUid: map['userUid'],
      postUid: map['postUid'],
      comment: map['comment'],
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      replies: List<CommentModel>.from(
        map['replies'].map(
          (pedal) => CommentModel.fromMap(pedal),
        ),
      ),
      likesCount: map['likesCount'] ?? 0,
      reportedBy: List<String>.from(map['reportedBy'] ?? []),
      rating: map['rating'] != null ? RatingModel.fromMap(map['rating']) : null,
    );
  }

  // Convert CommentModel to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userUid': userUid,
      'postUid': postUid,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'replies': replies.map((reply) => reply.toMap()).toList(),
      'likesCount': likesCount,
      'reportedBy': reportedBy,
      'rating': rating?.toMap(),
    };
  }

  //copy with
  CommentModel copyWith({
    String? uid,
    String? userUid,
    String? postUid,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CommentModel>? replies,
    int? likesCount,
    List<String>? reportedBy,
    RatingModel? rating,
  }) {
    return CommentModel(
      uid: uid ?? this.uid,
      userUid: userUid ?? this.userUid,
      postUid: postUid ?? this.postUid,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      replies: replies ?? this.replies,
      likesCount: likesCount ?? this.likesCount,
      reportedBy: reportedBy ?? this.reportedBy,
      rating: rating ?? this.rating,
    );
  }
}
