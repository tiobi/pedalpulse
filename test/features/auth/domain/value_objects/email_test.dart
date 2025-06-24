import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/auth/domain/value_objects/email.dart';

void main() {
  group('Email Value Object', () {
    group('Valid Emails', () {
      test('should accept valid email formats', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'first.last+tag@subdomain.example.com',
          'user123@test-domain.org',
          'simple@test.io',
        ];

        for (final emailString in validEmails) {
          final email = Email(emailString);
          expect(email.isValid, true, reason: '$emailString should be valid');
          expect(email.error, null, reason: '$emailString should have no error');
          expect(email.value, emailString);
          expect(email.toString(), emailString);
        }
      });
    });

    group('Invalid Emails', () {
      test('should reject invalid email formats', () {
        final invalidEmails = [
          'plainaddress',
          '@missingdomain.com',
          'missing@.com',
          'missing.domain@.com',
          'spaces in@email.com',
          'double@@domain.com',
          'trailing.dot@domain.com.',
          '.leading.dot@domain.com',
        ];

        for (final emailString in invalidEmails) {
          final email = Email(emailString);
          expect(email.isValid, false, reason: '$emailString should be invalid');
          expect(email.error, isNotNull, reason: '$emailString should have error');
        }
      });

      test('should reject empty email', () {
        final email = Email('');
        expect(email.isValid, false);
        expect(email.error, 'Email cannot be empty');
      });

      test('should provide appropriate error messages', () {
        final emptyEmail = Email('');
        expect(emptyEmail.error, 'Email cannot be empty');

        final invalidEmail = Email('invalid-email');
        expect(invalidEmail.error, 'Please enter a valid email address');
      });
    });

    group('Equality and Comparison', () {
      test('should be equal when values are the same', () {
        final email1 = Email('test@example.com');
        final email2 = Email('test@example.com');
        
        expect(email1.value, email2.value);
        expect(email1.toString(), email2.toString());
      });

      test('should not be equal when values are different', () {
        final email1 = Email('test1@example.com');
        final email2 = Email('test2@example.com');
        
        expect(email1.value, isNot(email2.value));
      });
    });

    group('Edge Cases', () {
      test('should handle special characters correctly', () {
        final email = Email('user+tag@example.com');
        expect(email.isValid, true);
        expect(email.error, null);
      });

      test('should handle numbers in email', () {
        final email = Email('user123@example123.com');
        expect(email.isValid, true);
        expect(email.error, null);
      });

      test('should handle long domain names', () {
        final email = Email('user@very-long-domain-name-that-is-still-valid.com');
        expect(email.isValid, true);
        expect(email.error, null);
      });
    });
  });
}