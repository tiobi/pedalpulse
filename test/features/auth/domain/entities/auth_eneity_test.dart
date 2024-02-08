import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity.dart';

void main() {
  test('AuthEntity Test', () {
    // Arrange
    const String tEmail = 'hello@world.com';
    const String tPassword = 'password1234';

    // Act
    const AuthEntity tAuthEntity = AuthEntity(
      email: tEmail,
      password: tPassword,
    );

    // Assert
    expect(tAuthEntity.email, tEmail);
    expect(tAuthEntity.password, tPassword);
  });
}
