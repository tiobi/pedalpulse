import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    final testDateTime = DateTime(2024, 1, 1);
    final testSettings = UserSettings.defaults();
    final testStats = UserStats.initial();

    group('Factory constructors', () {
      test('should create UserEntity with all required fields', () {
        final userEntity = UserEntity(
          uid: 'uid123',
          username: 'testuser',
          email: 'test@example.com',
          profileImageUrl: 'https://example.com/profile.jpg',
          backgroundImageUrl: 'https://example.com/background.jpg',
          bio: 'Test bio',
          joinedAt: testDateTime,
          lastActiveAt: testDateTime,
          settings: testSettings,
          stats: testStats,
        );

        expect(userEntity.uid, 'uid123');
        expect(userEntity.username, 'testuser');
        expect(userEntity.email, 'test@example.com');
        expect(userEntity.profileImageUrl, 'https://example.com/profile.jpg');
        expect(userEntity.backgroundImageUrl, 'https://example.com/background.jpg');
        expect(userEntity.bio, 'Test bio');
        expect(userEntity.joinedAt, testDateTime);
        expect(userEntity.lastActiveAt, testDateTime);
        expect(userEntity.settings, testSettings);
        expect(userEntity.stats, testStats);
      });

      test('should create UserEntity using create factory', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        );

        expect(userEntity.uid, 'uid123');
        expect(userEntity.username, 'test');
        expect(userEntity.email, 'test@example.com');
        expect(userEntity.profileImageUrl, '');
        expect(userEntity.backgroundImageUrl, '');
        expect(userEntity.bio, '');
        expect(userEntity.joinedAt, isA<DateTime>());
        expect(userEntity.lastActiveAt, isA<DateTime>());
        expect(userEntity.settings, isA<UserSettings>());
        expect(userEntity.stats, isA<UserStats>());
      });

      test('should create UserEntity with custom username using create factory', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
          username: 'customuser',
        );

        expect(userEntity.uid, 'uid123');
        expect(userEntity.username, 'customuser');
        expect(userEntity.email, 'test@example.com');
      });

      test('should extract username from email when not provided', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'john.doe@example.com',
        );

        expect(userEntity.username, 'john.doe');
      });
    });

    group('Validation getters', () {
      test('should return true when profile image URL is not empty', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        ).copyWith(profileImageUrl: 'https://example.com/profile.jpg');

        expect(userEntity.hasProfileImage, true);
      });

      test('should return false when profile image URL is empty', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        );

        expect(userEntity.hasProfileImage, false);
      });

      test('should return true when background image URL is not empty', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        ).copyWith(backgroundImageUrl: 'https://example.com/background.jpg');

        expect(userEntity.hasBackgroundImage, true);
      });

      test('should return false when background image URL is empty', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        );

        expect(userEntity.hasBackgroundImage, false);
      });

      test('should return true when bio is not empty', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        ).copyWith(bio: 'This is my bio');

        expect(userEntity.hasBio, true);
      });

      test('should return false when bio is empty', () {
        final userEntity = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        );

        expect(userEntity.hasBio, false);
      });
    });

    group('Immutability and copyWith', () {
      test('should support copyWith functionality', () {
        final original = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        );

        final updated = original.copyWith(
          username: 'newusername',
          bio: 'Updated bio',
        );

        expect(updated.uid, original.uid);
        expect(updated.email, original.email);
        expect(updated.username, 'newusername');
        expect(updated.bio, 'Updated bio');
        expect(original.username, 'test'); // Original unchanged
        expect(original.bio, ''); // Original unchanged
      });

      test('should support deep copyWith for nested objects', () {
        final original = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
        );

        final newSettings = original.settings.copyWith(isPrivate: true);
        final updated = original.copyWith(settings: newSettings);

        expect(updated.settings.isPrivate, true);
        expect(original.settings.isPrivate, false); // Original unchanged
      });
    });

    group('JSON serialization', () {
      test('should serialize to and from JSON correctly', () {
        final original = UserEntity.create(
          uid: 'uid123',
          email: 'test@example.com',
          username: 'testuser',
        ).copyWith(
          bio: 'Test bio',
          profileImageUrl: 'https://example.com/profile.jpg',
        );

        final json = original.toJson();
        final deserialized = UserEntity.fromJson(json);

        expect(deserialized.uid, original.uid);
        expect(deserialized.username, original.username);
        expect(deserialized.email, original.email);
        expect(deserialized.bio, original.bio);
        expect(deserialized.profileImageUrl, original.profileImageUrl);
        expect(deserialized.settings.isPrivate, original.settings.isPrivate);
        expect(deserialized.stats.postsCount, original.stats.postsCount);
      });
    });
  });

  group('UserSettings', () {
    test('should create UserSettings with defaults', () {
      final settings = UserSettings.defaults();

      expect(settings.isPrivate, false);
      expect(settings.allowNotifications, true);
      expect(settings.allowEmailNotifications, true);
      expect(settings.language, 'en');
      expect(settings.theme, 'system');
    });

    test('should create UserSettings with custom values', () {
      const settings = UserSettings(
        isPrivate: true,
        allowNotifications: false,
        allowEmailNotifications: false,
        language: 'es',
        theme: 'dark',
      );

      expect(settings.isPrivate, true);
      expect(settings.allowNotifications, false);
      expect(settings.allowEmailNotifications, false);
      expect(settings.language, 'es');
      expect(settings.theme, 'dark');
    });

    test('should support copyWith functionality', () {
      final original = UserSettings.defaults();
      final updated = original.copyWith(
        isPrivate: true,
        theme: 'dark',
      );

      expect(updated.isPrivate, true);
      expect(updated.theme, 'dark');
      expect(updated.allowNotifications, true); // Unchanged
      expect(original.isPrivate, false); // Original unchanged
    });

    test('should serialize to and from JSON correctly', () {
      const original = UserSettings(
        isPrivate: true,
        allowNotifications: false,
        allowEmailNotifications: true,
        language: 'fr',
        theme: 'light',
      );

      final json = original.toJson();
      final deserialized = UserSettings.fromJson(json);

      expect(deserialized.isPrivate, original.isPrivate);
      expect(deserialized.allowNotifications, original.allowNotifications);
      expect(deserialized.allowEmailNotifications, original.allowEmailNotifications);
      expect(deserialized.language, original.language);
      expect(deserialized.theme, original.theme);
    });
  });

  group('UserStats', () {
    test('should create UserStats with initial values', () {
      final stats = UserStats.initial();

      expect(stats.postsCount, 0);
      expect(stats.likesCount, 0);
      expect(stats.followersCount, 0);
      expect(stats.followingCount, 0);
    });

    test('should create UserStats with custom values', () {
      const stats = UserStats(
        postsCount: 10,
        likesCount: 25,
        followersCount: 100,
        followingCount: 50,
      );

      expect(stats.postsCount, 10);
      expect(stats.likesCount, 25);
      expect(stats.followersCount, 100);
      expect(stats.followingCount, 50);
    });

    test('should support copyWith functionality', () {
      final original = UserStats.initial();
      final updated = original.copyWith(
        postsCount: 5,
        likesCount: 15,
      );

      expect(updated.postsCount, 5);
      expect(updated.likesCount, 15);
      expect(updated.followersCount, 0); // Unchanged
      expect(updated.followingCount, 0); // Unchanged
      expect(original.postsCount, 0); // Original unchanged
    });

    test('should serialize to and from JSON correctly', () {
      const original = UserStats(
        postsCount: 20,
        likesCount: 45,
        followersCount: 200,
        followingCount: 150,
      );

      final json = original.toJson();
      final deserialized = UserStats.fromJson(json);

      expect(deserialized.postsCount, original.postsCount);
      expect(deserialized.likesCount, original.likesCount);
      expect(deserialized.followersCount, original.followersCount);
      expect(deserialized.followingCount, original.followingCount);
    });
  });
}