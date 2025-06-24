import 'package:dart_mappable/dart_mappable.dart';

part 'username.mapper.dart';

@MappableClass()
class Username with UsernameMappable {
  final String value;

  const Username(this.value);

  static const fromMap = UsernameMapper.fromMap;
  static const fromJson = UsernameMapper.fromJson;

  static const int minLength = 3;
  static const int maxLength = 30;

  bool get isValid {
    if (value.isEmpty) return false;
    if (value.length < minLength) return false;
    if (value.length > maxLength) return false;
    
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return usernameRegex.hasMatch(value);
  }

  bool get hasValidLength => 
      value.length >= minLength && value.length <= maxLength;

  bool get hasValidCharacters => RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value);

  String? get error {
    if (value.isEmpty) return 'Username cannot be empty';
    if (value.length < minLength) {
      return 'Username must be at least $minLength characters long';
    }
    if (value.length > maxLength) {
      return 'Username must be less than $maxLength characters long';
    }
    if (!hasValidCharacters) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  @override
  String toString() => value;
}