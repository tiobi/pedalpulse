import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/delete_user_usecase.dart';
import '../../domain/usecases/get_user_likes_usecase.dart';
import '../../domain/usecases/add_user_likes_usecase.dart';
import '../../domain/usecases/remove_user_like_usecase.dart';
import '../../domain/usecases/update_user_profile_image_usecase.dart';
import '../state/user_state.dart';

class UserViewModel extends ChangeNotifier {
  // Use cases
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final GetUserLikesUseCase getUserLikesUseCase;
  final AddUserLikesUseCase addUserLikesUseCase;
  final RemoveUserLikeUseCase removeUserLikeUseCase;
  final UpdateUserProfileImageUseCase updateUserProfileImageUseCase;

  // State
  UserState _state = UserState.initial();
  UserState get state => _state;

  // Getters for convenience
  UserEntity? get currentUser => _state.currentUser;
  bool get isLoading => _state.isLoading;
  bool get hasUser => _state.hasUser;
  List<String> get userLikes => _state.userLikes ?? [];

  // Constructor
  UserViewModel({
    required this.getUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required this.getUserLikesUseCase,
    required this.addUserLikesUseCase,
    required this.removeUserLikeUseCase,
    required this.updateUserProfileImageUseCase,
  });

  // Private methods
  void _updateState(UserState newState) {
    _state = newState;
    notifyListeners();
  }

  // Public methods for user operations

  /// Load user by UID
  Future<void> loadUser(String uid) async {
    _updateState(UserState.loading());

    final result = await getUserUseCase(uid: uid);

    result.fold(
      (failure) => _updateState(UserState.error(errorMessage: failure.message)),
      (user) async {
        // Also load user likes
        final likesResult = await getUserLikesUseCase(userUid: uid);
        final likes = likesResult.fold(
          (failure) => <String>[],
          (likesList) => likesList,
        );

        _updateState(UserState.loaded(user: user, userLikes: likes));
      },
    );
  }

  /// Update user profile
  Future<void> updateUser(UserEntity updatedUser) async {
    if (!_state.canPerformActions || _state.currentUser == null) return;

    _updateState(_state.copyWith(isUpdatingProfile: true));

    final result = await updateUserUseCase(userEntity: updatedUser);

    result.fold(
      (failure) => _updateState(_state.copyWith(
        isUpdatingProfile: false,
        errorMessage: failure.message,
      )),
      (user) => _updateState(_state.copyWith(
        currentUser: user,
        isUpdatingProfile: false,
        successMessage: 'Profile updated successfully',
        errorMessage: null,
      )),
    );
  }

  /// Update user profile image
  Future<void> updateProfileImage({
    XFile? profileImage,
    XFile? coverImage,
  }) async {
    if (!_state.canPerformActions || _state.currentUser == null) return;

    _updateState(_state.copyWith(isUpdatingProfileImage: true));

    final result = await updateUserProfileImageUseCase(
      uid: _state.currentUser!.uid,
      profileImage: profileImage,
      coverImage: coverImage,
    );

    result.fold(
      (failure) => _updateState(_state.copyWith(
        isUpdatingProfileImage: false,
        errorMessage: failure.message,
      )),
      (_) async {
        // Reload user data to get updated image URLs
        await loadUser(_state.currentUser!.uid);
        _updateState(_state.copyWith(
          isUpdatingProfileImage: false,
          successMessage: 'Profile image updated successfully',
          errorMessage: null,
        ));
      },
    );
  }

  /// Add a like to a post
  Future<void> addLike({
    required String postUid,
  }) async {
    if (!_state.canPerformActions || _state.currentUser == null) return;

    // Optimistic update
    final currentLikes = List<String>.from(_state.userLikes ?? []);
    if (!currentLikes.contains(postUid)) {
      currentLikes.add(postUid);
      _updateState(_state.copyWith(userLikes: currentLikes));
    }

    final result = await addUserLikesUseCase(
      userUid: _state.currentUser!.uid,
      postUid: postUid,
    );

    result.fold(
      (failure) {
        // Revert optimistic update
        final revertedLikes = List<String>.from(_state.userLikes ?? []);
        revertedLikes.remove(postUid);
        _updateState(_state.copyWith(
          userLikes: revertedLikes,
          errorMessage: failure.message,
        ));
      },
      (_) {
        // Success - the optimistic update was correct
        _updateState(_state.copyWith(
          successMessage: 'Post liked',
          errorMessage: null,
        ));
      },
    );
  }

  /// Remove a like from a post
  Future<void> removeLike({
    required String postUid,
  }) async {
    if (!_state.canPerformActions || _state.currentUser == null) return;

    // Optimistic update
    final currentLikes = List<String>.from(_state.userLikes ?? []);
    currentLikes.remove(postUid);
    _updateState(_state.copyWith(userLikes: currentLikes));

    final result = await removeUserLikeUseCase(
      userUid: _state.currentUser!.uid,
      postUid: postUid,
    );

    result.fold(
      (failure) {
        // Revert optimistic update
        final revertedLikes = List<String>.from(_state.userLikes ?? []);
        if (!revertedLikes.contains(postUid)) {
          revertedLikes.add(postUid);
        }
        _updateState(_state.copyWith(
          userLikes: revertedLikes,
          errorMessage: failure.message,
        ));
      },
      (_) {
        // Success - the optimistic update was correct
        _updateState(_state.copyWith(
          successMessage: 'Post unliked',
          errorMessage: null,
        ));
      },
    );
  }

  /// Toggle like status for a post
  Future<void> toggleLike({required String postUid}) async {
    if (isPostLiked(postUid)) {
      await removeLike(postUid: postUid);
    } else {
      await addLike(postUid: postUid);
    }
  }

  /// Check if a post is liked by the current user
  bool isPostLiked(String postUid) {
    return _state.userLikes?.contains(postUid) ?? false;
  }

  /// Delete user account
  Future<void> deleteUser() async {
    if (!_state.canPerformActions || _state.currentUser == null) return;

    _updateState(_state.copyWith(isUpdatingProfile: true));

    final result = await deleteUserUseCase(uid: _state.currentUser!.uid);

    result.fold(
      (failure) => _updateState(_state.copyWith(
        isUpdatingProfile: false,
        errorMessage: failure.message,
      )),
      (_) {
        _updateState(UserState.initial());
        // Note: You might want to also sign out the user here
      },
    );
  }

  /// Refresh user data
  Future<void> refresh() async {
    if (_state.currentUser != null) {
      await loadUser(_state.currentUser!.uid);
    }
  }

  /// Update user settings
  Future<void> updateSettings(UserSettings newSettings) async {
    if (!_state.canPerformActions || _state.currentUser == null) return;

    final updatedUser = _state.currentUser!.copyWith(settings: newSettings);
    await updateUser(updatedUser);
  }

  /// Clear messages
  void clearMessages() {
    _updateState(_state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }

  /// Reset to initial state
  void reset() {
    _updateState(UserState.initial());
  }

  @override
  void dispose() {
    super.dispose();
  }
}