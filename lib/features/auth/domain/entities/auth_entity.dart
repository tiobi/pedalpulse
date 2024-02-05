import 'package:dart_mappable/dart_mappable.dart';

part 'auth_entity.mapper.dart';

@MappableClass()
class AuthEntity with AuthEntityMappable {
  final String email;
  final String password;

  const AuthEntity({
    required this.email,
    required this.password,
  });
}
