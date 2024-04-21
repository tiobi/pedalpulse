import 'package:dart_mappable/dart_mappable.dart';
import '../../domain/entities/banner_entity.dart';

part 'banner_model.mapper.dart';

@MappableClass()
class BannerModel with BannerModelMappable {
  final String uid;
  final String postUrl;
  final String imageUrl;
  final String order;
  final int views;

  BannerModel({
    required this.uid,
    required this.postUrl,
    required this.imageUrl,
    required this.views,
    required this.order,
  });

  static const fromMap = BannerModelMapper.fromMap;
  static const fromJson = BannerModelMapper.fromJson;

  BannerEntity toEntity() {
    return BannerEntity(
      uid: uid,
      postUrl: postUrl,
      imageUrl: imageUrl,
      order: order,
      views: views,
    );
  }
}
