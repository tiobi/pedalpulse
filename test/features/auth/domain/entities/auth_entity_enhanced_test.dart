import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/auth/domain/entities/auth_entity_enhanced.dart';
import 'package:pedalpulse/features/auth/domain/value_objects/email.dart';
import 'package:pedalpulse/features/auth/domain/value_objects/password.dart';

void main() {
  group('AuthEntityEnhanced', () {
    group('Valid Entity Creation', () {
      test('should create valid auth entity with valid email and password', () {
        final email = Email('test@example.com');
        final password = Password('ValidPass123!');
        
        final authEntity = AuthEntityEnhanced(
          email: email,
          password: password,
        );
        
        expect(authEntity.email, email);
        expect(authEntity.password, password);
        expect(authEntity.isValid, true);
        expect(authEntity.validationErrors, isEmpty);
      });
    });

    group('Invalid Entity Creation', () {
      test('should create entity with invalid email', () {
        final invalidEmail = Email('invalid-email');
        final validPassword = Password('ValidPass123!');
        
        final authEntity = AuthEntityEnhanced(
          email: invalidEmail,
          password: validPassword,
        );
        
        expect(authEntity.isValid, false);
        expect(authEntity.validationErrors, contains('Please enter a valid email address'));
      });

      test('should create entity with invalid password', () {
        final validEmail = Email('test@example.com');
        final invalidPassword = Password('123');
        
        final authEntity = AuthEntityEnhanced(
          email: validEmail,
          password: invalidPassword,
        );
        
        expect(authEntity.isValid, false);
        expect(authEntity.validationErrors, contains('Password must be at least 6 characters long'));
      });

      test('should create entity with both invalid email and password', () {
        final invalidEmail = Email('invalid-email');
        final invalidPassword = Password('123');
        
        final authEntity = AuthEntityEnhanced(
          email: invalidEmail,
          password: invalidPassword,
        );
        
        expect(authEntity.isValid, false);
        expect(authEntity.validationErrors, hasLength(2));
        expect(authEntity.validationErrors, contains('Please enter a valid email address'));
        expect(authEntity.validationErrors, contains('Password must be at least 6 characters long'));
      });
    });

    group('Validation Logic', () {
      test('should validate email correctly', () {
        final validEmail = Email('valid@example.com');
        final invalidEmail = Email('invalid');
        final password = Password('ValidPass123!');
        
        final validEntity = AuthEntityEnhanced(email: validEmail, password: password);
        final invalidEntity = AuthEntityEnhanced(email: invalidEmail, password: password);
        
        expect(validEntity.isEmailValid, true);
        expect(invalidEntity.isEmailValid, false);
      });

      test('should validate password correctly', () {
        final email = Email('test@example.com');
        final validPassword = Password('ValidPass123!');
        final invalidPassword = Password('123');
        
        final validEntity = AuthEntityEnhanced(email: email, password: validPassword);
        final invalidEntity = AuthEntityEnhanced(email: email, password: invalidPassword);
        
        expect(validEntity.isPasswordValid, true);
        expect(invalidEntity.isPasswordValid, false);
      });

      test('should provide specific validation errors', () {
        final invalidEmail = Email('');
        final invalidPassword = Password('');
        
        final authEntity = AuthEntityEnhanced(
          email: invalidEmail,
          password: invalidPassword,
        );
        
        expect(authEntity.validationErrors, contains('Email cannot be empty'));
        expect(authEntity.validationErrors, contains('Password cannot be empty'));
      });
    });

    group('Password Strength Validation', () {
      test('should handle weak passwords', () {
        final email = Email('test@example.com');
        final weakPassword = Password('password');
        
        final authEntity = AuthEntityEnhanced(
          email: email,
          password: weakPassword,
        );
        
        expect(authEntity.password.strength, PasswordStrength.weak);
        expect(authEntity.isValid, true); // Weak passwords are still valid
      });

      test('should handle medium strength passwords', () {
        final email = Email('test@example.com');
        final mediumPassword = Password('Password123');
        
        final authEntity = AuthEntityEnhanced(
          email: email,
          password: mediumPassword,
        );
        
        expect(authEntity.password.strength, PasswordStrength.medium);
        expect(authEntity.isValid, true);
      });

      test('should handle strong passwords', () {
        final email = Email('test@example.com');
        final strongPassword = Password('StrongPass123!');
        
        final authEntity = AuthEntityEnhanced(
          email: email,
          password: strongPassword,
        );
        
        expect(authEntity.password.strength, PasswordStrength.strong);
        expect(authEntity.isValid, true);
      });
    });

    group('Edge Cases', () {
      test('should handle minimum valid credentials', () {
        final email = Email('a@b.co');
        final password = Password('123456');
        
        final authEntity = AuthEntityEnhanced(
          email: email,
          password: password,
        );
        
        expect(authEntity.isValid, true);
        expect(authEntity.validationErrors, isEmpty);
      });

      test('should handle maximum length values', () {
        final email = Email('verylongemailaddress@verylongdomainname.com');
        final password = Password('a' * Password.maxLength);
        
        final authEntity = AuthEntityEnhanced(
          email: email,
          password: password,
        );
        
        expect(authEntity.isValid, true);
        expect(authEntity.validationErrors, isEmpty);
      });

      test('should handle special characters in credentials', () {
        final email = Email('user+tag@example.com');
        final password = Password('Special!@#Password123');
        
        final authEntity = AuthEntityEnhanced(
          email: email,
          password: password,
        );
        
        expect(authEntity.isValid, true);
        expect(authEntity.validationErrors, isEmpty);
      });
    });

    group('ToString and Display', () {
      test('should not expose password in toString', () {
        final email = Email('test@example.com');
        final password = Password('SecretPassword123!');
        
        final authEntity = AuthEntityEnhanced(
          email: email,
          password: password,
        );
        
        final stringRepresentation = authEntity.toString();
        expect(stringRepresentation, contains('test@example.com'));
        expect(stringRepresentation, isNot(contains('SecretPassword123!')));
        expect(stringRepresentation, contains('***'));
      });
    });

    group('Real-world Scenarios', () {
      test('should handle typical sign-up credentials', () {
        final testCases = [
          ('john.doe@gmail.com', 'MyPassword123'),
          ('user+signup@company.co.uk', 'Complex!Pass2023'),
          ('student123@university.edu', 'StudentPass!'),
        ];

        for (final (emailStr, passwordStr) in testCases) {
          final email = Email(emailStr);
          final password = Password(passwordStr);
          final authEntity = AuthEntityEnhanced(email: email, password: password);
          
          expect(authEntity.isValid, true, 
                 reason: '$emailStr with $passwordStr should be valid');
        }
      });

      test('should reject common invalid sign-up attempts', () {
        final invalidCases = [
          ('plaintext', 'password'),
          ('user@', '123'),
          ('', ''),
          ('spaces in@email.com', 'validpass123'),
        ];

        for (final (emailStr, passwordStr) in invalidCases) {
          final email = Email(emailStr);
          final password = Password(passwordStr);
          final authEntity = AuthEntityEnhanced(email: email, password: password);
          
          expect(authEntity.isValid, false, 
                 reason: '$emailStr with $passwordStr should be invalid');
        }
      });
    });
  });
}