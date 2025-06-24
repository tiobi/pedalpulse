import 'package:dart_mappable/dart_mappable.dart';
import '../value_objects/email.dart';
import '../value_objects/password.dart';

part 'auth_entity_enhanced.mapper.dart';

@MappableClass()
class AuthEntityEnhanced with AuthEntityEnhancedMappable {
  final Email email;
  final Password password;

  const AuthEntityEnhanced({
    required this.email,
    required this.password,
  });

  static const fromMap = AuthEntityEnhancedMapper.fromMap;
  static const fromJson = AuthEntityEnhancedMapper.fromJson;

  factory AuthEntityEnhanced.create({
    required String email,
    required String password,
  }) {
    return AuthEntityEnhanced(
      email: Email(email),
      password: Password(password),
    );
  }

  bool get isValid => email.isValid && password.isValid;

  String? get validationError {
    if (!email.isValid) return email.error;
    if (!password.isValid) return password.error;
    return null;
  }
}