import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/user/domain/value_objects/image_url.dart';

void main() {
  group('ImageUrl Value Object', () {
    group('Valid URLs', () {
      test('should accept valid HTTPS URLs', () {
        final validUrls = [
          'https://example.com/image.jpg',
          'https://cdn.example.com/path/to/image.png',
          'https://storage.googleapis.com/bucket/image.jpeg',
          'https://firebasestorage.googleapis.com/v0/b/project/o/image.jpg',
          'https://subdomain.domain.com/very/long/path/to/image.gif',
        ];

        for (final urlString in validUrls) {
          final imageUrl = ImageUrl(urlString);
          expect(imageUrl.isValid, true, reason: '$urlString should be valid');
          expect(imageUrl.error, null, reason: '$urlString should have no error');
          expect(imageUrl.value, urlString);
          expect(imageUrl.toString(), urlString);
        }
      });

      test('should accept empty URL', () {
        final imageUrl = ImageUrl('');
        expect(imageUrl.isValid, true);
        expect(imageUrl.error, null);
        expect(imageUrl.isEmpty, true);
        expect(imageUrl.isSecure, false);
      });
    });

    group('Invalid URLs', () {
      test('should reject HTTP URLs (not secure)', () {
        final httpUrls = [
          'http://example.com/image.jpg',
          'http://cdn.example.com/image.png',
          'http://insecure-site.com/avatar.jpeg',
        ];

        for (final urlString in httpUrls) {
          final imageUrl = ImageUrl(urlString);
          expect(imageUrl.isValid, false, reason: '$urlString should be invalid');
          expect(imageUrl.error, contains('HTTPS'));
          expect(imageUrl.isSecure, false);
        }
      });

      test('should reject malformed URLs', () {
        final malformedUrls = [
          'not-a-url',
          'ftp://example.com/image.jpg',
          'https://',
          'https://.',
          'https://example',
          'example.com/image.jpg',
          'www.example.com/image.jpg',
        ];

        for (final urlString in malformedUrls) {
          final imageUrl = ImageUrl(urlString);
          expect(imageUrl.isValid, false, reason: '$urlString should be invalid');
          expect(imageUrl.error, isNotNull);
        }
      });

      test('should provide appropriate error messages', () {
        final httpUrl = ImageUrl('http://example.com/image.jpg');
        expect(httpUrl.error, 'Image URL must use HTTPS for security');

        final malformedUrl = ImageUrl('not-a-url');
        expect(malformedUrl.error, 'Please enter a valid URL');
      });
    });

    group('URL Properties', () {
      test('should correctly identify empty URLs', () {
        final emptyUrl = ImageUrl('');
        expect(emptyUrl.isEmpty, true);
        expect(emptyUrl.hasValue, false);
        
        final whitespaceUrl = ImageUrl('   ');
        expect(whitespaceUrl.isEmpty, true);
        expect(whitespaceUrl.hasValue, false);
        
        final validUrl = ImageUrl('https://example.com/image.jpg');
        expect(validUrl.isEmpty, false);
        expect(validUrl.hasValue, true);
      });

      test('should correctly identify secure URLs', () {
        final httpsUrl = ImageUrl('https://example.com/image.jpg');
        expect(httpsUrl.isSecure, true);
        
        final httpUrl = ImageUrl('http://example.com/image.jpg');
        expect(httpUrl.isSecure, false);
        
        final emptyUrl = ImageUrl('');
        expect(emptyUrl.isSecure, false);
      });

      test('should extract domain correctly', () {
        final testCases = {
          'https://example.com/image.jpg': 'example.com',
          'https://cdn.example.com/path/image.png': 'cdn.example.com',
          'https://storage.googleapis.com/bucket/image.jpeg': 'storage.googleapis.com',
          '': '',
        };

        testCases.forEach((url, expectedDomain) {
          final imageUrl = ImageUrl(url);
          expect(imageUrl.domain, expectedDomain, 
                 reason: '$url should have domain $expectedDomain');
        });
      });
    });

    group('URL Validation', () {
      test('should correctly validate URL format', () {
        final validFormat = ImageUrl('https://example.com/image.jpg');
        expect(validFormat.isValidFormat, true);
        
        final invalidFormat = ImageUrl('not-a-url');
        expect(invalidFormat.isValidFormat, false);
        
        final emptyFormat = ImageUrl('');
        expect(emptyFormat.isValidFormat, true); // Empty is considered valid format
      });

      test('should handle URLs with query parameters', () {
        final urlWithParams = ImageUrl('https://example.com/image.jpg?size=large&format=jpeg');
        expect(urlWithParams.isValid, true);
        expect(urlWithParams.isSecure, true);
        expect(urlWithParams.domain, 'example.com');
      });

      test('should handle URLs with fragments', () {
        final urlWithFragment = ImageUrl('https://example.com/image.jpg#section');
        expect(urlWithFragment.isValid, true);
        expect(urlWithFragment.isSecure, true);
        expect(urlWithFragment.domain, 'example.com');
      });
    });

    group('Real-world Examples', () {
      test('should handle common image hosting services', () {
        final realWorldUrls = [
          'https://i.imgur.com/abc123.jpg',
          'https://images.unsplash.com/photo-123/image.jpg',
          'https://cdn.pixabay.com/photo/2023/01/01/image.png',
          'https://firebasestorage.googleapis.com/v0/b/project/o/users%2Fuser123%2Favatar.jpg?alt=media',
          'https://github.com/user/repo/blob/main/avatar.png',
        ];

        for (final urlString in realWorldUrls) {
          final imageUrl = ImageUrl(urlString);
          expect(imageUrl.isValid, true, reason: '$urlString should be valid');
          expect(imageUrl.isSecure, true);
          expect(imageUrl.hasValue, true);
        }
      });

      test('should reject common invalid attempts', () {
        final invalidAttempts = [
          'image.jpg',
          'file:///path/to/image.jpg',
          'data:image/jpeg;base64,abc123',
          'javascript:alert("xss")',
          'ftp://example.com/image.jpg',
        ];

        for (final urlString in invalidAttempts) {
          final imageUrl = ImageUrl(urlString);
          expect(imageUrl.isValid, false, reason: '$urlString should be invalid');
        }
      });
    });

    group('Edge Cases', () {
      test('should handle very long URLs', () {
        final longPath = 'very/' * 50 + 'long/path/to/image.jpg';
        final longUrl = 'https://example.com/$longPath';
        final imageUrl = ImageUrl(longUrl);
        
        expect(imageUrl.isValid, true);
        expect(imageUrl.isSecure, true);
      });

      test('should handle URLs with special characters', () {
        final specialCharUrls = [
          'https://example.com/path%20with%20spaces/image.jpg',
          'https://example.com/path-with-dashes/image.jpg',
          'https://example.com/path_with_underscores/image.jpg',
          'https://example.com/path.with.dots/image.jpg',
        ];

        for (final urlString in specialCharUrls) {
          final imageUrl = ImageUrl(urlString);
          expect(imageUrl.isValid, true, reason: '$urlString should be valid');
        }
      });

      test('should handle internationalized domain names', () {
        final idnUrl = ImageUrl('https://xn--nxasmq6b.xn--j6w193g/image.jpg');
        expect(idnUrl.isValid, true);
        expect(idnUrl.isSecure, true);
      });
    });

    group('Whitespace Handling', () {
      test('should handle URLs with surrounding whitespace', () {
        final urlWithSpaces = ImageUrl('  https://example.com/image.jpg  ');
        expect(urlWithSpaces.isValid, true);
        expect(urlWithSpaces.value, '  https://example.com/image.jpg  ');
        expect(urlWithSpaces.isSecure, true);
      });

      test('should handle whitespace-only input', () {
        final whitespaceOnly = ImageUrl('   ');
        expect(whitespaceOnly.isValid, true);
        expect(whitespaceOnly.isEmpty, true);
        expect(whitespaceOnly.hasValue, false);
      });
    });

    group('Security Features', () {
      test('should enforce HTTPS requirement', () {
        final httpsUrl = ImageUrl('https://secure-site.com/image.jpg');
        expect(httpsUrl.isValid, true);
        expect(httpsUrl.isSecure, true);
        
        final httpUrl = ImageUrl('http://insecure-site.com/image.jpg');
        expect(httpUrl.isValid, false);
        expect(httpUrl.isSecure, false);
        expect(httpUrl.error, contains('HTTPS'));
      });

      test('should reject potentially dangerous schemes', () {
        final dangerousSchemes = [
          'javascript:alert("xss")',
          'data:text/html,<script>alert("xss")</script>',
          'file:///etc/passwd',
          'ftp://example.com/file',
        ];

        for (final urlString in dangerousSchemes) {
          final imageUrl = ImageUrl(urlString);
          expect(imageUrl.isValid, false, reason: '$urlString should be rejected');
        }
      });
    });
  });
}