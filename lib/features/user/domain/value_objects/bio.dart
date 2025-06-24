import 'package:dart_mappable/dart_mappable.dart';

part 'bio.mapper.dart';

@MappableClass()
class Bio with BioMappable {
  final String value;

  const Bio(this.value);

  static const fromMap = BioMapper.fromMap;
  static const fromJson = BioMapper.fromJson;

  static const int maxLength = 500;

  bool get isValid {
    return value.length <= maxLength;
  }

  bool get isEmpty => value.trim().isEmpty;
  
  int get characterCount => value.length;
  int get remainingCharacters => maxLength - characterCount;

  String? get error {
    if (value.length > maxLength) {
      return 'Bio must be less than $maxLength characters long';
    }
    return null;
  }

  String get displayValue => value.trim();

  @override
  String toString() => value;
}