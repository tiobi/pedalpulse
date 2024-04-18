import 'package:dart_mappable/dart_mappable.dart';
import '../../domain/entities/banner_entity.dart';

@MappableClass()
class BannerModel extends BannerEntity with BannerModelMapper {}
