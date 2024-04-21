// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModelDepr {
  final String uid;
  final String username;
  final String email;
  final String profileImageUrl;
  final String backgroundImageUrl;
  final String bio;
  final DateTime joinedAt;

  UserModelDepr({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.backgroundImageUrl,
    required this.bio,
    required this.joinedAt,
  });

  UserModelDepr copyWith({
    String? uid,
    String? username,
    String? email,
    String? profileImageUrl,
    String? backgroundImageUrl,
    String? bio,
    DateTime? joinedAt,
  }) {
    return UserModelDepr(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      bio: bio ?? this.bio,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'backgroundImageUrl': backgroundImageUrl,
      'bio': bio,
      'joinedAt': joinedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModelDepr.fromMap(Map<String, dynamic> map) {
    return UserModelDepr(
      uid: map['uid'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
      backgroundImageUrl: map['backgroundImageUrl'] as String,
      bio: map['bio'] as String,
      joinedAt: DateTime.fromMillisecondsSinceEpoch(map['joinedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModelDepr.fromJson(String source) =>
      UserModelDepr.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, email: $email, profileImageUrl: $profileImageUrl, backgroundImageUrl: $backgroundImageUrl, bio: $bio, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(covariant UserModelDepr other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl &&
        other.backgroundImageUrl == backgroundImageUrl &&
        other.bio == bio &&
        other.joinedAt == joinedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        username.hashCode ^
        email.hashCode ^
        profileImageUrl.hashCode ^
        backgroundImageUrl.hashCode ^
        bio.hashCode ^
        joinedAt.hashCode;
  }
}
