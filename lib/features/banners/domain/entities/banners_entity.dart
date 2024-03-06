import 'package:dart_mappable/dart_mappable.dart';

part 'banners_entity.mapper.dart';

@MappableClass()
class BannerEntity with BannerEntityMappable {
  final String uid;
  final String postUrl;
  final String imageUrl;
  final String order;
  final int views;

  BannerEntity({
    required this.uid,
    required this.postUrl,
    required this.imageUrl,
    required this.views,
    this.order = '0',
  });

  static const fromMap = BannerEntityMapper.fromMap;
  static const fromJson = BannerEntityMapper.fromJson;
}
