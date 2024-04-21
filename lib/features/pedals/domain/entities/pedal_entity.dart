import 'package:dart_mappable/dart_mappable.dart';

import 'rating_entity.dart';

part 'pedal_entity.mapper.dart';

@MappableClass()
class PedalEntity with PedalEntityMappable {
  final String uid;
  final String name;
  final String brand;
  final List<String> category;
  final String description;
  final List<String> imageUrls;
  final int commentsCount;
  final int likesCount;
  final RatingEntity rating;

  PedalEntity({
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

  static const fromMap = PedalEntityMapper.fromMap;
  static const fromJson = PedalEntityMapper.fromJson;
}
