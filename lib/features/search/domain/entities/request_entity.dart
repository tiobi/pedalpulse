import 'package:dart_mappable/dart_mappable.dart';

part 'request_entity.mapper.dart';

@MappableClass()
class RequestEntity with RequestEntityMappable {
  final String manufacturer;
  final String model;
  final String description;

  RequestEntity({
    required this.manufacturer,
    required this.model,
    required this.description,
  });
}
