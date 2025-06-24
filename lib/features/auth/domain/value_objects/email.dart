import 'package:dart_mappable/dart_mappable.dart';

part 'email.mapper.dart';

@MappableClass()
class Email with EmailMappable {
  final String value;

  const Email(this.value);

  static const fromMap = EmailMapper.fromMap;
  static const fromJson = EmailMapper.fromJson;

  bool get isValid {
    if (value.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    return emailRegex.hasMatch(value);
  }

  String? get error {
    if (value.isEmpty) return 'Email cannot be empty';
    if (!isValid) return 'Please enter a valid email address';
    return null;
  }

  @override
  String toString() => value;
}