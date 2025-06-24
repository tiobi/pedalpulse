import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/user/domain/usecases/validate_user_profile_usecase.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity_enhanced.dart';
import 'package:pedalpulse/features/user/domain/value_objects/username.dart';
import 'package:pedalpulse/features/user/domain/value_objects/bio.dart';
import 'package:pedalpulse/features/user/domain/value_objects/image_url.dart';

void main() {
  group('ValidateUserProfileUseCase', () {
    late ValidateUserProfileUseCase useCase;

    setUp(() {
      useCase = ValidateUserProfileUseCase();
    });

    group('Profile Completeness Validation', () {
      test('should calculate correct completeness for incomplete profile', () {
        final incompleteUser = _createUser(
          username: 'newuser',
          bio: '',
          imageUrl: '',
        );

        final result = useCase(ValidateUserProfileParams(incompleteUser));

        expect(result.completenessPercentage, 20); // Only username
        expect(result.isComplete, false);
        expect(result.suggestions, hasLength(2));
        expect(result.suggestions, contains('Add a bio to tell others about yourself'));
        expect(result.suggestions, contains('Upload a profile picture'));
      });

      test('should calculate correct completeness for partial profile', () {
        final partialUser = _createUser(
          username: 'partialuser',
          bio: 'I have a bio',
          imageUrl: '',
        );

        final result = useCase(ValidateUserProfileParams(partialUser));

        expect(result.completenessPercentage, 40); // Username + bio
        expect(result.isComplete, false);
        expect(result.suggestions, hasLength(1));
        expect(result.suggestions, contains('Upload a profile picture'));
      });

      test('should calculate correct completeness for complete profile', () {
        final completeUser = _createUser(
          username: 'completeuser',
          bio: 'I have a complete profile',
          imageUrl: 'https://example.com/avatar.jpg',
        );

        final result = useCase(ValidateUserProfileParams(completeUser));

        expect(result.completenessPercentage, 60); // Username + bio + image
        expect(result.isComplete, true);
        expect(result.suggestions, isEmpty);
      });
    });

    group('Business Rules Validation', () {
      test('should detect restricted usernames', () {
        final restrictedUsernames = [
          'admin',
          'administrator',
          'root',
          'moderator',
          'support',
          'help',
          'api',
          'www',
          'mail',
          'ftp',
        ];

        for (final restrictedUsername in restrictedUsernames) {
          final user = _createUser(username: restrictedUsername);
          final result = useCase(ValidateUserProfileParams(user));

          expect(result.businessRuleViolations, 
                 contains('Username "$restrictedUsername" is not allowed'));
        }
      });

      test('should detect insecure links in bio', () {
        final insecureLinks = [
          'Check out http://insecure-site.com',
          'Visit my blog at http://my-blog.net/posts',
          'Download from http://downloads.example.com/file.zip',
          'My portfolio: http://portfolio.com and other stuff',
        ];

        for (final bioWithInsecureLink in insecureLinks) {
          final user = _createUser(bio: bioWithInsecureLink);
          final result = useCase(ValidateUserProfileParams(user));

          expect(result.businessRuleViolations, 
                 contains('Bio contains insecure HTTP links. Please use HTTPS links only.'));
        }
      });

      test('should allow secure HTTPS links in bio', () {
        final secureLinks = [
          'Check out https://secure-site.com',
          'Visit my blog at https://my-blog.net/posts',
          'My portfolio: https://portfolio.com',
          'Download from https://downloads.example.com/file.zip',
        ];

        for (final bioWithSecureLink in secureLinks) {
          final user = _createUser(bio: bioWithSecureLink);
          final result = useCase(ValidateUserProfileParams(user));

          expect(result.businessRuleViolations, 
                 isNot(contains('Bio contains insecure HTTP links. Please use HTTPS links only.')));
        }
      });

      test('should allow bio without any links', () {
        final biosWithoutLinks = [
          'I love guitar pedals',
          'Professional musician and producer',
          'Collecting vintage gear since 1995',
          'Making music with passion 🎸🎵',
        ];

        for (final bioWithoutLinks in biosWithoutLinks) {
          final user = _createUser(bio: bioWithoutLinks);
          final result = useCase(ValidateUserProfileParams(user));

          expect(result.businessRuleViolations, 
                 isNot(contains('Bio contains insecure HTTP links. Please use HTTPS links only.')));
        }
      });
    });

    group('Validation Summary', () {
      test('should provide empty validation for perfect profile', () {
        final perfectUser = _createUser(
          username: 'perfectuser',
          bio: 'Perfect profile with https://secure-site.com link',
          imageUrl: 'https://example.com/avatar.jpg',
        );

        final result = useCase(ValidateUserProfileParams(perfectUser));

        expect(result.isComplete, true);
        expect(result.completenessPercentage, 60);
        expect(result.suggestions, isEmpty);
        expect(result.businessRuleViolations, isEmpty);
        expect(result.hasViolations, false);
      });

      test('should provide comprehensive validation for problematic profile', () {
        final problematicUser = _createUser(
          username: 'admin', // Restricted
          bio: 'Check out http://insecure-site.com', // Insecure link
          imageUrl: '', // Missing
        );

        final result = useCase(ValidateUserProfileParams(problematicUser));

        expect(result.isComplete, false);
        expect(result.completenessPercentage, 20);
        expect(result.suggestions, hasLength(2));
        expect(result.businessRuleViolations, hasLength(2));
        expect(result.hasViolations, true);
        
        expect(result.businessRuleViolations, contains('Username "admin" is not allowed'));
        expect(result.businessRuleViolations, 
               contains('Bio contains insecure HTTP links. Please use HTTPS links only.'));
      });
    });

    group('Edge Cases', () {
      test('should handle empty bio correctly', () {
        final userWithEmptyBio = _createUser(bio: '');
        final result = useCase(ValidateUserProfileParams(userWithEmptyBio));

        expect(result.suggestions, contains('Add a bio to tell others about yourself'));
        expect(result.businessRuleViolations, 
               isNot(contains('Bio contains insecure HTTP links. Please use HTTPS links only.')));
      });

      test('should handle whitespace-only bio', () {
        final userWithWhitespaceBio = _createUser(bio: '   ');
        final result = useCase(ValidateUserProfileParams(userWithWhitespaceBio));

        expect(result.suggestions, contains('Add a bio to tell others about yourself'));
      });

      test('should handle bio with mixed secure and insecure links', () {
        final mixedLinksBio = 'Visit https://secure.com and http://insecure.com';
        final user = _createUser(bio: mixedLinksBio);
        final result = useCase(ValidateUserProfileParams(user));

        expect(result.businessRuleViolations, 
               contains('Bio contains insecure HTTP links. Please use HTTPS links only.'));
      });

      test('should handle case-insensitive restricted usernames', () {
        final caseVariations = ['ADMIN', 'Admin', 'aDmIn', 'ROOT', 'Root'];

        for (final username in caseVariations) {
          final user = _createUser(username: username);
          final result = useCase(ValidateUserProfileParams(user));

          expect(result.businessRuleViolations, 
                 contains('Username "${username.toLowerCase()}" is not allowed'));
        }
      });

      test('should handle usernames that contain restricted words', () {
        final containsRestricted = ['adminuser', 'useradmin', 'rootaccess', 'moderator123'];

        for (final username in containsRestricted) {
          final user = _createUser(username: username);
          final result = useCase(ValidateUserProfileParams(user));

          expect(result.businessRuleViolations, isEmpty, 
                 reason: '$username should not be flagged as it only contains restricted words');
        }
      });
    });

    group('Real-world Scenarios', () {
      test('should validate typical musician profiles', () {
        final musicianProfiles = [
          {
            'username': 'guitarist_pro',
            'bio': 'Professional guitarist and pedal enthusiast. Check out my work at https://mymusic.com',
            'imageUrl': 'https://example.com/musician.jpg',
            'expectComplete': true,
            'expectViolations': false,
          },
          {
            'username': 'pedal_collector',
            'bio': 'Collecting vintage pedals since 1995',
            'imageUrl': '',
            'expectComplete': false,
            'expectViolations': false,
          },
          {
            'username': 'admin_guitar', // Contains but not exactly restricted
            'bio': 'Guitar admin for my band',
            'imageUrl': 'https://example.com/band.jpg',
            'expectComplete': true,
            'expectViolations': false,
          },
        ];

        for (final profile in musicianProfiles) {
          final user = _createUser(
            username: profile['username'] as String,
            bio: profile['bio'] as String,
            imageUrl: profile['imageUrl'] as String,
          );
          
          final result = useCase(ValidateUserProfileParams(user));

          expect(result.isComplete, profile['expectComplete'], 
                 reason: 'Profile ${profile['username']} completeness mismatch');
          expect(result.hasViolations, profile['expectViolations'], 
                 reason: 'Profile ${profile['username']} violations mismatch');
        }
      });

      test('should validate problematic user attempts', () {
        final problematicProfiles = [
          {
            'username': 'support',
            'bio': 'I provide support',
            'imageUrl': 'https://example.com/avatar.jpg',
            'expectedViolation': 'Username "support" is not allowed',
          },
          {
            'username': 'normaluser',
            'bio': 'Visit my old site http://legacy.com',
            'imageUrl': 'https://example.com/avatar.jpg',
            'expectedViolation': 'Bio contains insecure HTTP links. Please use HTTPS links only.',
          },
          {
            'username': 'api',
            'bio': 'Download from http://files.com and visit http://more.com',
            'imageUrl': '',
            'expectedViolation': 'Username "api" is not allowed',
          },
        ];

        for (final profile in problematicProfiles) {
          final user = _createUser(
            username: profile['username'] as String,
            bio: profile['bio'] as String,
            imageUrl: profile['imageUrl'] as String,
          );
          
          final result = useCase(ValidateUserProfileParams(user));

          expect(result.hasViolations, true, 
                 reason: 'Profile ${profile['username']} should have violations');
          expect(result.businessRuleViolations, 
                 contains(profile['expectedViolation']),
                 reason: 'Profile ${profile['username']} should contain expected violation');
        }
      });
    });

    group('Suggestion Generation', () {
      test('should provide specific suggestions based on missing elements', () {
        final scenarios = [
          {
            'bio': '',
            'imageUrl': '',
            'expectedSuggestions': [
              'Add a bio to tell others about yourself',
              'Upload a profile picture',
            ],
          },
          {
            'bio': 'I have a bio',
            'imageUrl': '',
            'expectedSuggestions': [
              'Upload a profile picture',
            ],
          },
          {
            'bio': '',
            'imageUrl': 'https://example.com/avatar.jpg',
            'expectedSuggestions': [
              'Add a bio to tell others about yourself',
            ],
          },
          {
            'bio': 'Complete bio',
            'imageUrl': 'https://example.com/avatar.jpg',
            'expectedSuggestions': <String>[],
          },
        ];

        for (final scenario in scenarios) {
          final user = _createUser(
            bio: scenario['bio'] as String,
            imageUrl: scenario['imageUrl'] as String,
          );
          
          final result = useCase(ValidateUserProfileParams(user));
          final expectedSuggestions = scenario['expectedSuggestions'] as List<String>;

          expect(result.suggestions, hasLength(expectedSuggestions.length));
          for (final suggestion in expectedSuggestions) {
            expect(result.suggestions, contains(suggestion));
          }
        }
      });
    });
  });
}

UserEntityEnhanced _createUser({
  String username = 'testuser',
  String bio = 'Test bio',
  String imageUrl = 'https://example.com/avatar.jpg',
}) {
  return UserEntityEnhanced(
    uid: 'user123',
    email: 'test@example.com',
    username: Username(username),
    bio: Bio(bio),
    imageUrl: ImageUrl(imageUrl),
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
  );
}