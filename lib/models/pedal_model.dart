import 'package:pedalpulse/models/rating_model.dart';

class PedalModel {
  final String uid;
  final String name;
  final String brand;
  final List<String> category;
  final String description;
  final List<String> imageUrls;
  final int commentsCount;
  final int likesCount;
  final RatingModel rating;

  PedalModel({
    required this.uid,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.imageUrls,
    required this.rating,
    this.commentsCount = 0,
    this.likesCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'brand': brand,
      'category': category,
      'description': description,
      'imageUrls': imageUrls,
      'rating': rating.toMap(),
      'commentsCount': commentsCount,
      'likesCount': likesCount,
    };
  }

  factory PedalModel.fromMap(Map<String, dynamic> map) {
    return PedalModel(
      uid: map['uid'],
      name: map['name'],
      brand: map['brand'],
      category: List<String>.from(map['category']),
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls']),
      rating: RatingModel.fromMap(map['rating']),
      commentsCount: map['commentsCount'] ?? 0,
      likesCount: map['likesCount'] ?? 0,
    );
  }
}
