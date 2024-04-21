import 'package:dart_mappable/dart_mappable.dart';
import 'package:pedalpulse/features/pedals/domain/entities/rating_entity.dart';

part 'rating_model.mapper.dart';

@MappableClass()
class RatingModel with RatingModelMappable {
  final num overall;
  final num accessibility;
  final num sound;
  final num buildQuality;
  final num versatility;

  RatingModel({
    required this.overall,
    required this.accessibility,
    required this.sound,
    required this.buildQuality,
    required this.versatility,
  });

  static const fromMap = RatingModelMapper.fromMap;
  static const fromJson = RatingModelMapper.fromJson;

  RatingEntity toEntity() {
    return RatingEntity(
      overall: overall,
      accessibility: accessibility,
      sound: sound,
      buildQuality: buildQuality,
      versatility: versatility,
    );
  }
}
