import 'package:dart_mappable/dart_mappable.dart';

part 'password.mapper.dart';

@MappableClass()
class Password with PasswordMappable {
  final String value;

  const Password(this.value);

  static const fromMap = PasswordMapper.fromMap;
  static const fromJson = PasswordMapper.fromJson;

  static const int minLength = 6;
  static const int maxLength = 128;

  bool get isValid {
    if (value.isEmpty) return false;
    if (value.length < minLength) return false;
    if (value.length > maxLength) return false;
    
    return true;
  }

  bool get hasUppercase => value.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => value.contains(RegExp(r'[a-z]'));
  bool get hasDigit => value.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar => value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  PasswordStrength get strength {
    if (!isValid) return PasswordStrength.invalid;
    
    int score = 0;
    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasDigit) score++;
    if (hasSpecialChar) score++;
    if (value.length >= 8) score++;
    if (value.length >= 12) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  String? get error {
    if (value.isEmpty) return 'Password cannot be empty';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }
    if (value.length > maxLength) {
      return 'Password must be less than $maxLength characters long';
    }
    return null;
  }

  @override
  String toString() => '***';
}

enum PasswordStrength {
  invalid,
  weak,
  medium,
  strong,
}