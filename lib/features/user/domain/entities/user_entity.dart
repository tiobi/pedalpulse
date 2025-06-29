import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String uid,
    required String username,
    required String email,
    required String profileImageUrl,
    required String backgroundImageUrl,
    required String bio,
    required DateTime joinedAt,
    DateTime? lastActiveAt,
    required UserSettings settings,
    required UserStats stats,
  }) = _UserEntity;

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

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}

extension UserEntityValidation on UserEntity {
  bool get hasProfileImage => profileImageUrl.isNotEmpty;
  bool get hasBackgroundImage => backgroundImageUrl.isNotEmpty;
  bool get hasBio => bio.isNotEmpty;
}

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    required bool isPrivate,
    required bool allowNotifications,
    required bool allowEmailNotifications,
    required String language,
    required String theme,
  }) = _UserSettings;

  factory UserSettings.defaults() => const UserSettings(
        isPrivate: false,
        allowNotifications: true,
        allowEmailNotifications: true,
        language: 'en',
        theme: 'system',
      );

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    required int postsCount,
    required int likesCount,
    required int followersCount,
    required int followingCount,
  }) = _UserStats;

  factory UserStats.initial() => const UserStats(
        postsCount: 0,
        likesCount: 0,
        followersCount: 0,
        followingCount: 0,
      );

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
