import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/auth/domain/value_objects/password.dart';

void main() {
  group('Password Value Object', () {
    group('Valid Passwords', () {
      test('should accept valid password formats', () {
        final validPasswords = [
          'SimplePass123',
          'Complex!Password@2023',
          'MySecure#Pass123',
          'Valid123',
          'minimum6',
        ];

        for (final passwordString in validPasswords) {
          final password = Password(passwordString);
          expect(password.isValid, true, reason: '$passwordString should be valid');
          expect(password.error, null, reason: '$passwordString should have no error');
          expect(password.value, passwordString);
          expect(password.toString(), '***');
        }
      });
    });

    group('Invalid Passwords', () {
      test('should reject passwords that are too short', () {
        final shortPasswords = ['', '1', '12', '123', '1234', '12345'];

        for (final passwordString in shortPasswords) {
          final password = Password(passwordString);
          expect(password.isValid, false, reason: '$passwordString should be invalid');
          expect(password.error, contains('at least ${Password.minLength} characters'));
        }
      });

      test('should reject passwords that are too long', () {
        final longPassword = 'a' * (Password.maxLength + 1);
        final password = Password(longPassword);
        
        expect(password.isValid, false);
        expect(password.error, contains('less than ${Password.maxLength} characters'));
      });

      test('should provide appropriate error messages', () {
        final emptyPassword = Password('');
        expect(emptyPassword.error, 'Password cannot be empty');

        final shortPassword = Password('123');
        expect(shortPassword.error, 'Password must be at least ${Password.minLength} characters long');
      });
    });

    group('Password Strength', () {
      test('should detect weak passwords', () {
        final weakPasswords = [
          'password',
          '123456',
          'simple',
          'weak123',
          'noUpper',
        ];

        for (final passwordString in weakPasswords) {
          final password = Password(passwordString);
          if (password.isValid) {
            expect(password.strength, PasswordStrength.weak, 
                   reason: '$passwordString should be weak');
          }
        }
      });

      test('should detect medium strength passwords', () {
        final mediumPasswords = [
          'Password123',
          'MyPass123',
          'Valid1234',
          'Medium123',
        ];

        for (final passwordString in mediumPasswords) {
          final password = Password(passwordString);
          expect(password.strength, PasswordStrength.medium,
                 reason: '$passwordString should be medium');
        }
      });

      test('should detect strong passwords', () {
        final strongPasswords = [
          'MyStrong!Pass123',
          'Complex@Password2023',
          'VerySecure#123',
          'StrongPass!@#123',
        ];

        for (final passwordString in strongPasswords) {
          final password = Password(passwordString);
          expect(password.strength, PasswordStrength.strong,
                 reason: '$passwordString should be strong');
        }
      });

      test('should mark invalid passwords as invalid strength', () {
        final invalidPasswords = ['', '123', 'ab'];

        for (final passwordString in invalidPasswords) {
          final password = Password(passwordString);
          expect(password.strength, PasswordStrength.invalid);
        }
      });
    });

    group('Character Type Detection', () {
      test('should detect uppercase characters', () {
        final password = Password('TestPassword');
        expect(password.hasUppercase, true);
        
        final noUppercase = Password('testpassword');
        expect(noUppercase.hasUppercase, false);
      });

      test('should detect lowercase characters', () {
        final password = Password('TestPassword');
        expect(password.hasLowercase, true);
        
        final noLowercase = Password('TESTPASSWORD');
        expect(noLowercase.hasLowercase, false);
      });

      test('should detect digits', () {
        final password = Password('TestPassword123');
        expect(password.hasDigit, true);
        
        final noDigits = Password('TestPassword');
        expect(noDigits.hasDigit, false);
      });

      test('should detect special characters', () {
        final password = Password('TestPassword!@#');
        expect(password.hasSpecialChar, true);
        
        final noSpecialChars = Password('TestPassword123');
        expect(noSpecialChars.hasSpecialChar, false);
      });
    });

    group('Security Features', () {
      test('should not expose password value in toString', () {
        final password = Password('MySecretPassword123!');
        expect(password.toString(), '***');
        expect(password.toString(), isNot(contains('MySecretPassword123!')));
      });

      test('should handle various special characters', () {
        final specialChars = ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')', '.', '?', '"', ':', '{', '}', '|', '<', '>'];
        
        for (final char in specialChars) {
          final password = Password('Test123$char');
          expect(password.hasSpecialChar, true, reason: 'Should detect $char as special character');
        }
      });
    });

    group('Edge Cases', () {
      test('should handle minimum valid length', () {
        final password = Password('123456');
        expect(password.isValid, true);
        expect(password.value.length, Password.minLength);
      });

      test('should handle maximum valid length', () {
        final maxPassword = 'a' * Password.maxLength;
        final password = Password(maxPassword);
        expect(password.isValid, true);
        expect(password.value.length, Password.maxLength);
      });

      test('should handle unicode characters', () {
        final password = Password('Påssw0rd123!');
        expect(password.isValid, true);
        expect(password.hasSpecialChar, true);
      });
    });
  });
}