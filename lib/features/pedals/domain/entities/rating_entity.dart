import 'package:dart_mappable/dart_mappable.dart';

part 'rating_entity.mapper.dart';

@MappableClass()
class RatingEntity with RatingEntityMappable {
  final num overall;
  final num accessibility;
  final num sound;
  final num buildQuality;
  final num versatility;

  RatingEntity({
    required this.overall,
    required this.accessibility,
    required this.sound,
    required this.buildQuality,
    required this.versatility,
  });

  static const fromMap = RatingEntityMapper.fromMap;
  static const fromJson = RatingEntityMapper.fromJson;
}
