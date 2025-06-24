import 'package:dart_mappable/dart_mappable.dart';

part 'image_url.mapper.dart';

@MappableClass()
class ImageUrl with ImageUrlMappable {
  final String value;

  const ImageUrl(this.value);

  static const fromMap = ImageUrlMapper.fromMap;
  static const fromJson = ImageUrlMapper.fromJson;

  bool get isValid {
    if (value.isEmpty) return true;
    
    try {
      Uri.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool get isEmpty => value.trim().isEmpty;
  bool get isNotEmpty => !isEmpty;

  bool get isHttps => value.startsWith('https://');
  bool get isFirebaseStorage => value.contains('firebasestorage.googleapis.com');

  String? get error {
    if (value.isNotEmpty && !isValid) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  Uri? get uri {
    try {
      return Uri.parse(value);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => value;
}