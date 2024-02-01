// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:pedalpulse/models/pedal_model.dart';

class PostModel {
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

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userUid': userUid,
      'username': username,
      'userProfileImageUrl': userProfileImageUrl,
      'imageUrls': imageUrls,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'likes': likes,
      'reports': reports,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'pedalList': pedalList.map((pedal) => pedal.toMap()).toList(),
      'pedalUids': pedalList.map((pedal) => pedal.uid).toList(),
      'views': views,
    };
  }

  // from map
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

  // copy with
  PostModel copyWith({
    String? uid,
    String? userUid,
    String? username,
    String? userProfileImageUrl,
    List<String>? imageUrls,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? likes,
    List<String>? reports,
    int? likesCount,
    int? commentsCount,
    List<PedalModel>? pedalList,
    List<String>? pedalUids,
    int? views,
  }) {
    return PostModel(
      uid: uid ?? this.uid,
      userUid: userUid ?? this.userUid,
      username: username ?? this.username,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      reports: reports ?? this.reports,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      pedalList: pedalList ?? this.pedalList,
      pedalUids: pedalUids ?? this.pedalUids,
      views: views ?? this.views,
    );
  }
}
