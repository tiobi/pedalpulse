import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String username,
    required String email,
    required String profileImageUrl,
    required String backgroundImageUrl,
    required String bio,
    required DateTime joinedAt,
    DateTime? lastActiveAt,
    required UserSettingsModel settings,
    required UserStatsModel stats,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      username: username,
      email: email,
      profileImageUrl: profileImageUrl,
      backgroundImageUrl: backgroundImageUrl,
      bio: bio,
      joinedAt: joinedAt,
      lastActiveAt: lastActiveAt,
      settings: settings.toEntity(),
      stats: stats.toEntity(),
    );
  }

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      username: entity.username,
      email: entity.email,
      profileImageUrl: entity.profileImageUrl,
      backgroundImageUrl: entity.backgroundImageUrl,
      bio: entity.bio,
      joinedAt: entity.joinedAt,
      lastActiveAt: entity.lastActiveAt,
      settings: UserSettingsModel.fromEntity(entity.settings),
      stats: UserStatsModel.fromEntity(entity.stats),
    );
  }
}

@freezed
class UserSettingsModel with _$UserSettingsModel {
  const factory UserSettingsModel({
    required bool isPrivate,
    required bool allowNotifications,
    required bool allowEmailNotifications,
    required String language,
    required String theme,
  }) = _UserSettingsModel;

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);
}

extension UserSettingsModelMapper on UserSettingsModel {
  UserSettings toEntity() {
    return UserSettings(
      isPrivate: isPrivate,
      allowNotifications: allowNotifications,
      allowEmailNotifications: allowEmailNotifications,
      language: language,
      theme: theme,
    );
  }

  static UserSettingsModel fromEntity(UserSettings entity) {
    return UserSettingsModel(
      isPrivate: entity.isPrivate,
      allowNotifications: entity.allowNotifications,
      allowEmailNotifications: entity.allowEmailNotifications,
      language: entity.language,
      theme: entity.theme,
    );
  }
}

@freezed
class UserStatsModel with _$UserStatsModel {
  const factory UserStatsModel({
    required int postsCount,
    required int likesCount,
    required int followersCount,
    required int followingCount,
  }) = _UserStatsModel;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);
}

extension UserStatsModelMapper on UserStatsModel {
  UserStats toEntity() {
    return UserStats(
      postsCount: postsCount,
      likesCount: likesCount,
      followersCount: followersCount,
      followingCount: followingCount,
    );
  }

  static UserStatsModel fromEntity(UserStats entity) {
    return UserStatsModel(
      postsCount: entity.postsCount,
      likesCount: entity.likesCount,
      followersCount: entity.followersCount,
      followingCount: entity.followingCount,
    );
  }
}
