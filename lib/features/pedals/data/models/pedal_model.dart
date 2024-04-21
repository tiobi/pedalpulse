import 'package:dart_mappable/dart_mappable.dart';

import '../../domain/entities/pedal_entity.dart';
import 'rating_model.dart';

part 'pedal_model.mapper.dart';

@MappableClass()
class PedalModel with PedalModelMappable {
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

  static const fromMap = PedalModelMapper.fromMap;
  static const fromJson = PedalModelMapper.fromJson;

  PedalEntity toEntity() {
    return PedalEntity(
      uid: uid,
      name: name,
      brand: brand,
      category: category,
      description: description,
      imageUrls: imageUrls,
      rating: rating.toEntity(),
      commentsCount: commentsCount,
      likesCount: likesCount,
    );
  }
}
