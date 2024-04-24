import 'package:dart_mappable/dart_mappable.dart';

part 'request_model.mapper.dart';

@MappableClass()
class RequestModel with RequestModelMappable {
  final String manufacturer;
  final String model;
  final String description;

  RequestModel({
    required this.manufacturer,
    required this.model,
    required this.description,
  });
}
