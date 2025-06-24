import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity_enhanced.dart';
import 'package:pedalpulse/features/user/domain/value_objects/username.dart';
import 'package:pedalpulse/features/user/domain/value_objects/bio.dart';
import 'package:pedalpulse/features/user/domain/value_objects/image_url.dart';

void main() {
  group('UserEntityEnhanced', () {
    group('Valid Entity Creation', () {
      test('should create valid user entity with all fields', () {
        final username = Username('testuser');
        final bio = Bio('I love guitar pedals!');
        final imageUrl = ImageUrl('https://example.com/avatar.jpg');
        
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: username,
          bio: bio,
          imageUrl: imageUrl,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );
        
        expect(userEntity.uid, 'user123');
        expect(userEntity.email, 'test@example.com');
        expect(userEntity.username, username);
        expect(userEntity.bio, bio);
        expect(userEntity.imageUrl, imageUrl);
        expect(userEntity.isValid, true);
        expect(userEntity.validationErrors, isEmpty);
      });

      test('should create valid user entity with minimal fields', () {
        final username = Username('testuser');
        
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: username,
          bio: Bio(''),
          imageUrl: ImageUrl(''),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );
        
        expect(userEntity.isValid, true);
        expect(userEntity.validationErrors, isEmpty);
        expect(userEntity.bio.isEmpty, true);
        expect(userEntity.imageUrl.isEmpty, true);
      });
    });

    group('Invalid Entity Creation', () {
      test('should create entity with invalid username', () {
        final invalidUsername = Username('ab');
        final bio = Bio('Valid bio');
        final imageUrl = ImageUrl('https://example.com/avatar.jpg');
        
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: invalidUsername,
          bio: bio,
          imageUrl: imageUrl,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );
        
        expect(userEntity.isValid, false);
        expect(userEntity.validationErrors, contains('Username must be at least 3 characters long'));
      });

      test('should create entity with invalid bio', () {
        final username = Username('validuser');
        final invalidBio = Bio('a' * (Bio.maxLength + 1));
        final imageUrl = ImageUrl('https://example.com/avatar.jpg');
        
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: username,
          bio: invalidBio,
          imageUrl: imageUrl,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );
        
        expect(userEntity.isValid, false);
        expect(userEntity.validationErrors, contains('Bio must be less than ${Bio.maxLength} characters long'));
      });

      test('should create entity with invalid image URL', () {
        final username = Username('validuser');
        final bio = Bio('Valid bio');
        final invalidImageUrl = ImageUrl('http://insecure.com/avatar.jpg');
        
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: username,
          bio: bio,
          imageUrl: invalidImageUrl,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );
        
        expect(userEntity.isValid, false);
        expect(userEntity.validationErrors, contains('Image URL must use HTTPS for security'));
      });

      test('should create entity with multiple validation errors', () {
        final invalidUsername = Username('ab');
        final invalidBio = Bio('a' * (Bio.maxLength + 1));
        final invalidImageUrl = ImageUrl('not-a-url');
        
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: invalidUsername,
          bio: invalidBio,
          imageUrl: invalidImageUrl,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        );
        
        expect(userEntity.isValid, false);
        expect(userEntity.validationErrors, hasLength(3));
      });
    });

    group('Validation Helpers', () {
      test('should validate username correctly', () {
        final validUser = _createUserEntity(username: Username('validuser'));
        final invalidUser = _createUserEntity(username: Username('ab'));
        
        expect(validUser.isUsernameValid, true);
        expect(invalidUser.isUsernameValid, false);
      });

      test('should validate bio correctly', () {
        final validUser = _createUserEntity(bio: Bio('Valid bio'));
        final invalidUser = _createUserEntity(bio: Bio('a' * (Bio.maxLength + 1)));
        
        expect(validUser.isBioValid, true);
        expect(invalidUser.isBioValid, false);
      });

      test('should validate image URL correctly', () {
        final validUser = _createUserEntity(imageUrl: ImageUrl('https://example.com/avatar.jpg'));
        final invalidUser = _createUserEntity(imageUrl: ImageUrl('http://insecure.com/avatar.jpg'));
        
        expect(validUser.isImageUrlValid, true);
        expect(invalidUser.isImageUrlValid, false);
      });
    });

    group('Profile Completeness', () {
      test('should calculate profile completeness correctly', () {
        final incompleteUser = _createUserEntity(
          bio: Bio(''),
          imageUrl: ImageUrl(''),
        );
        expect(incompleteUser.profileCompleteness, 20); // Only username

        final partialUser = _createUserEntity(
          bio: Bio('Some bio'),
          imageUrl: ImageUrl(''),
        );
        expect(partialUser.profileCompleteness, 40); // Username + bio

        final completeUser = _createUserEntity(
          bio: Bio('Complete bio'),
          imageUrl: ImageUrl('https://example.com/avatar.jpg'),
        );
        expect(completeUser.profileCompleteness, 60); // Username + bio + image
      });

      test('should identify if profile is complete', () {
        final incompleteUser = _createUserEntity(
          bio: Bio(''),
          imageUrl: ImageUrl(''),
        );
        expect(incompleteUser.isProfileComplete, false);

        final completeUser = _createUserEntity(
          bio: Bio('Complete bio'),
          imageUrl: ImageUrl('https://example.com/avatar.jpg'),
        );
        expect(completeUser.isProfileComplete, true);
      });

      test('should provide completion suggestions', () {
        final incompleteUser = _createUserEntity(
          bio: Bio(''),
          imageUrl: ImageUrl(''),
        );
        
        final suggestions = incompleteUser.profileCompletionSuggestions;
        expect(suggestions, contains('Add a bio to tell others about yourself'));
        expect(suggestions, contains('Upload a profile picture'));
      });
    });

    group('Display Properties', () {
      test('should provide display name', () {
        final user = _createUserEntity(username: Username('testuser'));
        expect(user.displayName, 'testuser');
      });

      test('should provide avatar URL', () {
        final userWithAvatar = _createUserEntity(
          imageUrl: ImageUrl('https://example.com/avatar.jpg'),
        );
        expect(userWithAvatar.avatarUrl, 'https://example.com/avatar.jpg');

        final userWithoutAvatar = _createUserEntity(
          imageUrl: ImageUrl(''),
        );
        expect(userWithoutAvatar.avatarUrl, isEmpty);
      });

      test('should provide bio display', () {
        final userWithBio = _createUserEntity(bio: Bio('My bio'));
        expect(userWithBio.bioDisplay, 'My bio');

        final userWithoutBio = _createUserEntity(bio: Bio(''));
        expect(userWithoutBio.bioDisplay, isEmpty);
      });
    });

    group('Business Logic', () {
      test('should identify new users', () {
        final newUser = _createUserEntity(
          createdAt: DateTime.now().subtract(Duration(minutes: 30)),
        );
        expect(newUser.isNewUser, true);

        final oldUser = _createUserEntity(
          createdAt: DateTime.now().subtract(Duration(days: 2)),
        );
        expect(oldUser.isNewUser, false);
      });

      test('should identify recently updated profiles', () {
        final recentlyUpdated = _createUserEntity(
          updatedAt: DateTime.now().subtract(Duration(minutes: 30)),
        );
        expect(recentlyUpdated.wasRecentlyUpdated, true);

        final notRecentlyUpdated = _createUserEntity(
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
        );
        expect(notRecentlyUpdated.wasRecentlyUpdated, false);
      });

      test('should check if profile needs update', () {
        final needsUpdate = _createUserEntity(
          bio: Bio(''),
          imageUrl: ImageUrl(''),
        );
        expect(needsUpdate.needsProfileUpdate, true);

        final complete = _createUserEntity(
          bio: Bio('Complete bio'),
          imageUrl: ImageUrl('https://example.com/avatar.jpg'),
        );
        expect(complete.needsProfileUpdate, false);
      });
    });

    group('Edge Cases', () {
      test('should handle users created and updated at same time', () {
        final now = DateTime.now();
        final user = _createUserEntity(
          createdAt: now,
          updatedAt: now,
        );
        
        expect(user.createdAt, user.updatedAt);
      });

      test('should handle maximum length values', () {
        final user = _createUserEntity(
          username: Username('a' * Username.maxLength),
          bio: Bio('a' * Bio.maxLength),
        );
        
        expect(user.isValid, true);
      });

      test('should handle special characters in content', () {
        final user = _createUserEntity(
          username: Username('user_123'),
          bio: Bio('Bio with émojis 🎸🎵 and special chars!'),
        );
        
        expect(user.isValid, true);
      });
    });

    group('Real-world Scenarios', () {
      test('should handle typical user profiles', () {
        final musicians = [
          _createUserEntity(
            username: Username('guitarist_pro'),
            bio: Bio('Professional guitarist and pedal enthusiast'),
            imageUrl: ImageUrl('https://example.com/musician.jpg'),
          ),
          _createUserEntity(
            username: Username('pedal_collector'),
            bio: Bio('Collecting vintage pedals since 1995'),
            imageUrl: ImageUrl('https://storage.googleapis.com/avatar.png'),
          ),
        ];

        for (final user in musicians) {
          expect(user.isValid, true);
          expect(user.isProfileComplete, true);
          expect(user.profileCompleteness, greaterThanOrEqualTo(60));
        }
      });

      test('should handle incomplete new user profiles', () {
        final newUsers = [
          _createUserEntity(
            username: Username('newuser'),
            bio: Bio(''),
            imageUrl: ImageUrl(''),
          ),
          _createUserEntity(
            username: Username('another_new_user'),
            bio: Bio('Just starting out'),
            imageUrl: ImageUrl(''),
          ),
        ];

        for (final user in newUsers) {
          expect(user.isValid, true);
          expect(user.isProfileComplete, false);
          expect(user.needsProfileUpdate, true);
        }
      });
    });
  });
}

UserEntityEnhanced _createUserEntity({
  String uid = 'user123',
  String email = 'test@example.com',
  Username? username,
  Bio? bio,
  ImageUrl? imageUrl,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return UserEntityEnhanced(
    uid: uid,
    email: email,
    username: username ?? Username('testuser'),
    bio: bio ?? Bio('Test bio'),
    imageUrl: imageUrl ?? ImageUrl('https://example.com/avatar.jpg'),
    createdAt: createdAt ?? DateTime(2023, 1, 1),
    updatedAt: updatedAt ?? DateTime(2023, 1, 1),
  );
}