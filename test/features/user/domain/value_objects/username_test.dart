import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/user/domain/value_objects/username.dart';

void main() {
  group('Username Value Object', () {
    group('Valid Usernames', () {
      test('should accept valid username formats', () {
        final validUsernames = [
          'validuser',
          'user123',
          'test_user',
          'User_Name_123',
          'a' * Username.minLength,
          'a' * Username.maxLength,
        ];

        for (final usernameString in validUsernames) {
          final username = Username(usernameString);
          expect(username.isValid, true, reason: '$usernameString should be valid');
          expect(username.error, null, reason: '$usernameString should have no error');
          expect(username.value, usernameString);
          expect(username.toString(), usernameString);
        }
      });
    });

    group('Invalid Usernames', () {
      test('should reject usernames that are too short', () {
        final shortUsernames = ['', 'a', 'ab'];

        for (final usernameString in shortUsernames) {
          final username = Username(usernameString);
          expect(username.isValid, false, reason: '$usernameString should be invalid');
          expect(username.error, contains('at least ${Username.minLength} characters'));
        }
      });

      test('should reject usernames that are too long', () {
        final longUsername = 'a' * (Username.maxLength + 1);
        final username = Username(longUsername);
        
        expect(username.isValid, false);
        expect(username.error, contains('less than ${Username.maxLength} characters'));
      });

      test('should reject usernames with invalid characters', () {
        final invalidUsernames = [
          'user@name',
          'user name',
          'user-name',
          'user.name',
          'user!name',
          'user#name',
          'user%name',
          'üser',
        ];

        for (final usernameString in invalidUsernames) {
          final username = Username(usernameString);
          expect(username.isValid, false, reason: '$usernameString should be invalid');
          expect(username.error, contains('letters, numbers, and underscores'));
        }
      });

      test('should provide appropriate error messages', () {
        final emptyUsername = Username('');
        expect(emptyUsername.error, 'Username cannot be empty');

        final shortUsername = Username('ab');
        expect(shortUsername.error, 'Username must be at least ${Username.minLength} characters long');

        final longUsername = Username('a' * (Username.maxLength + 1));
        expect(longUsername.error, 'Username must be less than ${Username.maxLength} characters long');

        final invalidUsername = Username('user@name');
        expect(invalidUsername.error, 'Username can only contain letters, numbers, and underscores');
      });
    });

    group('Validation Helpers', () {
      test('should correctly check valid length', () {
        final validLength = Username('validuser');
        expect(validLength.hasValidLength, true);
        
        final shortLength = Username('ab');
        expect(shortLength.hasValidLength, false);
        
        final longLength = Username('a' * (Username.maxLength + 1));
        expect(longLength.hasValidLength, false);
      });

      test('should correctly check valid characters', () {
        final validChars = Username('valid_user123');
        expect(validChars.hasValidCharacters, true);
        
        final invalidChars = Username('invalid@user');
        expect(invalidChars.hasValidCharacters, false);
      });
    });

    group('Boundary Testing', () {
      test('should handle minimum valid length', () {
        final minUsername = 'a' * Username.minLength;
        final username = Username(minUsername);
        expect(username.isValid, true);
        expect(username.hasValidLength, true);
      });

      test('should handle maximum valid length', () {
        final maxUsername = 'a' * Username.maxLength;
        final username = Username(maxUsername);
        expect(username.isValid, true);
        expect(username.hasValidLength, true);
      });

      test('should reject one character over minimum', () {
        final tooShort = 'a' * (Username.minLength - 1);
        final username = Username(tooShort);
        expect(username.isValid, false);
        expect(username.hasValidLength, false);
      });

      test('should reject one character over maximum', () {
        final tooLong = 'a' * (Username.maxLength + 1);
        final username = Username(tooLong);
        expect(username.isValid, false);
        expect(username.hasValidLength, false);
      });
    });

    group('Character Type Support', () {
      test('should support letters only', () {
        final lettersOnly = Username('username');
        expect(lettersOnly.isValid, true);
        expect(lettersOnly.hasValidCharacters, true);
      });

      test('should support numbers only', () {
        final numbersOnly = Username('123456');
        expect(numbersOnly.isValid, true);
        expect(numbersOnly.hasValidCharacters, true);
      });

      test('should support underscores', () {
        final withUnderscores = Username('user_name_123');
        expect(withUnderscores.isValid, true);
        expect(withUnderscores.hasValidCharacters, true);
      });

      test('should support mixed case', () {
        final mixedCase = Username('UserName123');
        expect(mixedCase.isValid, true);
        expect(mixedCase.hasValidCharacters, true);
      });
    });

    group('Real-world Examples', () {
      test('should handle typical gaming usernames', () {
        final gamingUsernames = [
          'player_one',
          'GamerGirl123',
          'ProGamer2023',
          'user_12345',
          'TestUser',
        ];

        for (final usernameString in gamingUsernames) {
          final username = Username(usernameString);
          expect(username.isValid, true, reason: '$usernameString should be valid');
        }
      });

      test('should reject common invalid attempts', () {
        final invalidAttempts = [
          'user name',  // spaces
          'user-name',  // hyphens
          'user.name',  // dots
          'user@domain', // email format
          'user+tag',   // plus signs
        ];

        for (final usernameString in invalidAttempts) {
          final username = Username(usernameString);
          expect(username.isValid, false, reason: '$usernameString should be invalid');
        }
      });
    });
  });
}