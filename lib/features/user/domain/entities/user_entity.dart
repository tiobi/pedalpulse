import 'package:dart_mappable/dart_mappable.dart';

part 'user_entity.mapper.dart';

@MappableClass()
class UserEntity with UserEntityMappable {
  final String uid;
  final String username;
  final String email;
  final String profileImageUrl;
  final String backgroundImageUrl;
  final String bio;
  final DateTime joinedAt;
  final DateTime? lastActiveAt;
  final UserSettings settings;
  final UserStats stats;

  const UserEntity({
    required this.uid,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.backgroundImageUrl,
    required this.bio,
    required this.joinedAt,
    this.lastActiveAt,
    required this.settings,
    required this.stats,
  });

  factory UserEntity.create({
    required String uid,
    required String email,
    String? username,
  }) =>
      UserEntity(
        uid: uid,
        username: username ?? email.split('@')[0],
        email: email,
        profileImageUrl: '',
        backgroundImageUrl: '',
        bio: '',
        joinedAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
        settings: UserSettings.defaults(),
        stats: UserStats.initial(),
      );

  bool get hasProfileImage => profileImageUrl.isNotEmpty;
  bool get hasBackgroundImage => backgroundImageUrl.isNotEmpty;
  bool get hasBio => bio.isNotEmpty;

  static const fromMap = UserEntityMapper.fromMap;
  static const fromJson = UserEntityMapper.fromJson;
}

@MappableClass()
class UserSettings with UserSettingsMappable {
  final bool isPrivate;
  final bool allowNotifications;
  final bool allowEmailNotifications;
  final String language;
  final String theme;

  const UserSettings({
    required this.isPrivate,
    required this.allowNotifications,
    required this.allowEmailNotifications,
    required this.language,
    required this.theme,
  });

  factory UserSettings.defaults() => const UserSettings(
        isPrivate: false,
        allowNotifications: true,
        allowEmailNotifications: true,
        language: 'en',
        theme: 'system',
      );

  static const fromMap = UserSettingsMapper.fromMap;
  static const fromJson = UserSettingsMapper.fromJson;
}

@MappableClass()
class UserStats with UserStatsMappable {
  final int postsCount;
  final int likesCount;
  final int followersCount;
  final int followingCount;

  const UserStats({
    required this.postsCount,
    required this.likesCount,
    required this.followersCount,
    required this.followingCount,
  });

  factory UserStats.initial() => const UserStats(
        postsCount: 0,
        likesCount: 0,
        followersCount: 0,
        followingCount: 0,
      );

  static const fromMap = UserStatsMapper.fromMap;
  static const fromJson = UserStatsMapper.fromJson;
}
