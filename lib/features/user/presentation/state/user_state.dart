import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part '.g/user_state.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    UserEntity? currentUser,
    required bool isLoading,
    required bool isInitialized,
    String? errorMessage,
    String? successMessage,
    List<String>? userLikes,
    required bool isUpdatingProfile,
    required bool isUpdatingProfileImage,
  }) = _UserState;

  factory UserState.initial() => const UserState(
        currentUser: null,
        isLoading: false,
        isInitialized: false,
        userLikes: null,
        isUpdatingProfile: false,
        isUpdatingProfileImage: false,
      );

  factory UserState.loading() => const UserState(
        currentUser: null,
        isLoading: true,
        isInitialized: false,
        userLikes: null,
        isUpdatingProfile: false,
        isUpdatingProfileImage: false,
      );

  factory UserState.loaded({
    required UserEntity user,
    List<String>? userLikes,
  }) =>
      UserState(
        currentUser: user,
        isLoading: false,
        isInitialized: true,
        userLikes: userLikes ?? [],
        isUpdatingProfile: false,
        isUpdatingProfileImage: false,
      );

  factory UserState.error({
    required String errorMessage,
    UserEntity? currentUser,
    bool? wasInitialized,
  }) =>
      UserState(
        currentUser: currentUser,
        isLoading: false,
        isInitialized: wasInitialized ?? false,
        errorMessage: errorMessage,
        userLikes: null,
        isUpdatingProfile: false,
        isUpdatingProfileImage: false,
      );

  factory UserState.updating({
    required UserEntity currentUser,
    required bool isUpdatingProfile,
    required bool isUpdatingProfileImage,
    List<String>? userLikes,
  }) =>
      UserState(
        currentUser: currentUser,
        isLoading: false,
        isInitialized: true,
        userLikes: userLikes,
        isUpdatingProfile: isUpdatingProfile,
        isUpdatingProfileImage: isUpdatingProfileImage,
      );

  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);
}

extension UserStateExtensions on UserState {
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get hasUser => currentUser != null;
  bool get isReady => isInitialized && !isLoading;
  bool get canPerformActions => isReady && !isUpdatingProfile && !isUpdatingProfileImage;
  bool get isAnyUpdateInProgress => isUpdatingProfile || isUpdatingProfileImage;
}