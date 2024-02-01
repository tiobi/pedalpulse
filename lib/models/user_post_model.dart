class UserPostModel {
  final String userUid;
  final String postUid;
  final String postTitle;
  DateTime createdAt;

  UserPostModel({
    required this.userUid,
    required this.postUid,
    required this.postTitle,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userUid': userUid,
      'postUid': postUid,
      'postTitle': postTitle,
      'createdAt': createdAt,
    };
  }

  factory UserPostModel.fromMap(Map<String, dynamic> map) {
    return UserPostModel(
      userUid: map['userUid'],
      postUid: map['postUid'],
      postTitle: map['postTitle'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}
