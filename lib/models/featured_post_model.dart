class FeaturedPostModel {
  final String uid;
  final String postUrl;
  final String imageUrl;
  final String order;
  final int views;

  FeaturedPostModel({
    required this.uid,
    required this.postUrl,
    required this.imageUrl,
    required this.views,
    this.order = '0',
  });

  factory FeaturedPostModel.fromMap(Map<String, dynamic> json) {
    return FeaturedPostModel(
      uid: json['uid'],
      postUrl: json['postUrl'],
      imageUrl: json['imageUrl'],
      views: json['views'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'postUrl': postUrl,
      'imageUrl': imageUrl,
      'views': views,
      'order': order,
    };
  }
}
