import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/user/domain/value_objects/bio.dart';

void main() {
  group('Bio Value Object', () {
    group('Valid Bios', () {
      test('should accept valid bio content', () {
        final validBios = [
          '',
          'Short bio',
          'I love guitar pedals and making music!',
          'A longer bio that describes the user\'s interests and hobbies in detail.',
          'Bio with numbers 123 and special chars!',
          'a' * Bio.maxLength,
        ];

        for (final bioString in validBios) {
          final bio = Bio(bioString);
          expect(bio.isValid, true, reason: '$bioString should be valid');
          expect(bio.error, null, reason: '$bioString should have no error');
          expect(bio.value, bioString);
          expect(bio.toString(), bioString);
        }
      });
    });

    group('Invalid Bios', () {
      test('should reject bios that are too long', () {
        final longBio = 'a' * (Bio.maxLength + 1);
        final bio = Bio(longBio);
        
        expect(bio.isValid, false);
        expect(bio.error, 'Bio must be less than ${Bio.maxLength} characters long');
      });

      test('should provide appropriate error messages', () {
        final longBio = Bio('a' * (Bio.maxLength + 1));
        expect(longBio.error, 'Bio must be less than ${Bio.maxLength} characters long');
      });
    });

    group('Bio Properties', () {
      test('should correctly identify empty bios', () {
        final emptyBio = Bio('');
        expect(emptyBio.isEmpty, true);
        expect(emptyBio.displayValue, '');
        
        final whitespaceBio = Bio('   ');
        expect(whitespaceBio.isEmpty, true);
        expect(whitespaceBio.displayValue, '');
        
        final nonEmptyBio = Bio('Hello world');
        expect(nonEmptyBio.isEmpty, false);
        expect(nonEmptyBio.displayValue, 'Hello world');
      });

      test('should correctly count characters', () {
        final bio = Bio('Hello world!');
        expect(bio.characterCount, 12);
        expect(bio.remainingCharacters, Bio.maxLength - 12);
        
        final emptyBio = Bio('');
        expect(emptyBio.characterCount, 0);
        expect(emptyBio.remainingCharacters, Bio.maxLength);
      });

      test('should handle display value correctly', () {
        final bioWithSpaces = Bio('  Hello world  ');
        expect(bioWithSpaces.displayValue, 'Hello world');
        expect(bioWithSpaces.value, '  Hello world  ');
        
        final normalBio = Bio('Hello world');
        expect(normalBio.displayValue, 'Hello world');
      });
    });

    group('Character Counting', () {
      test('should count characters correctly for various inputs', () {
        final testCases = {
          '': 0,
          'a': 1,
          'Hello': 5,
          'Hello world!': 12,
          'Multi\nline\nbio': 14,
          'Bio with émojis 😊🎸': 19,
        };

        testCases.forEach((bioText, expectedCount) {
          final bio = Bio(bioText);
          expect(bio.characterCount, expectedCount, 
                 reason: '$bioText should have $expectedCount characters');
          expect(bio.remainingCharacters, Bio.maxLength - expectedCount);
        });
      });
    });

    group('Boundary Testing', () {
      test('should handle maximum valid length', () {
        final maxBio = 'a' * Bio.maxLength;
        final bio = Bio(maxBio);
        expect(bio.isValid, true);
        expect(bio.characterCount, Bio.maxLength);
        expect(bio.remainingCharacters, 0);
      });

      test('should reject one character over maximum', () {
        final tooLongBio = 'a' * (Bio.maxLength + 1);
        final bio = Bio(tooLongBio);
        expect(bio.isValid, false);
        expect(bio.error, isNotNull);
      });
    });

    group('Special Characters and Content', () {
      test('should handle newlines and special characters', () {
        final bioWithNewlines = Bio('Line 1\nLine 2\nLine 3');
        expect(bioWithNewlines.isValid, true);
        expect(bioWithNewlines.isEmpty, false);
        
        final bioWithSpecialChars = Bio('Bio with special chars: !@#\$%^&*()');
        expect(bioWithSpecialChars.isValid, true);
        expect(bioWithSpecialChars.isEmpty, false);
      });

      test('should handle unicode characters', () {
        final unicodeBio = Bio('Bio with émojis 😊🎸🎵 and ümlauts');
        expect(unicodeBio.isValid, true);
        expect(unicodeBio.isEmpty, false);
      });

      test('should handle HTML-like content', () {
        final htmlLikeBio = Bio('Bio with <tags> and & entities');
        expect(htmlLikeBio.isValid, true);
        expect(htmlLikeBio.isEmpty, false);
      });
    });

    group('Real-world Examples', () {
      test('should handle typical user bios', () {
        final realWorldBios = [
          'Guitar enthusiast and pedal collector',
          'Music producer from Los Angeles. Love vintage gear!',
          'Playing guitar for 15+ years. Always looking for new sounds.',
          '🎸 Musician | 🎵 Producer | 📍 Nashville',
          'Check out my latest album: bit.ly/mymusic',
        ];

        for (final bioText in realWorldBios) {
          final bio = Bio(bioText);
          expect(bio.isValid, true, reason: '$bioText should be valid');
          expect(bio.isEmpty, false);
        }
      });

      test('should handle edge cases users might enter', () {
        final edgeCases = [
          '   ',  // Only whitespace
          '\n\n\n',  // Only newlines
          'a' * Bio.maxLength,  // Exactly max length
          '',  // Empty string
        ];

        for (final bioText in edgeCases) {
          final bio = Bio(bioText);
          expect(bio.isValid, true, reason: '$bioText should be valid');
        }
      });
    });

    group('Whitespace Handling', () {
      test('should preserve original value but trim display value', () {
        final spacesAtEnd = Bio('Hello world   ');
        expect(spacesAtEnd.value, 'Hello world   ');
        expect(spacesAtEnd.displayValue, 'Hello world');
        
        final spacesAtStart = Bio('   Hello world');
        expect(spacesAtStart.value, '   Hello world');
        expect(spacesAtStart.displayValue, 'Hello world');
        
        final spacesBoth = Bio('   Hello world   ');
        expect(spacesBoth.value, '   Hello world   ');
        expect(spacesBoth.displayValue, 'Hello world');
      });
    });
  });
}