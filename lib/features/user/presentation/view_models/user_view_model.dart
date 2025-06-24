import 'package:flutter/material.dart';
import 'package:pedalpulse/features/auth/domain/usecases/get_current_user_uid_usecase.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity.dart';
import 'package:pedalpulse/features/user/domain/usecases/add_user_likes_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/delete_user_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/get_user_likes_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/get_user_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/remove_user_like_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/update_user_profile_image_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/update_user_usecase.dart';
import '../state/user_state.dart';

class UserViewModel extends ChangeNotifier {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final GetUserLikesUseCase _getUserLikesUseCase;
  final AddUserLikesUseCase _addUserLikesUseCase;
  final RemoveUserLikeUseCase _removeUserLikeUseCase;
  final DeleteUserUseCase _deleteUserUseCase;
  final UpdateUserProfileImageUseCase _updateUserProfileImageUseCase;
  final GetCurrentUserUidUseCase _getCurrentUserUidUseCase;

  UserViewModel({
    required GetUserUseCase getUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required GetUserLikesUseCase getUserLikesUseCase,
    required AddUserLikesUseCase addUserLikesUseCase,
    required RemoveUserLikeUseCase removeUserLikeUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    required UpdateUserProfileImageUseCase updateUserProfileImageUseCase,
    required GetCurrentUserUidUseCase getCurrentUserUidUseCase,
  })  : _getUserUseCase = getUserUseCase,
        _updateUserUseCase = updateUserUseCase,
        _getUserLikesUseCase = getUserLikesUseCase,
        _addUserLikesUseCase = addUserLikesUseCase,
        _removeUserLikeUseCase = removeUserLikeUseCase,
        _deleteUserUseCase = deleteUserUseCase,
        _updateUserProfileImageUseCase = updateUserProfileImageUseCase,
        _getCurrentUserUidUseCase = getCurrentUserUidUseCase;

  UserState _state = const UserState();
  UserState get state => _state;

  void _updateState(UserState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> getUser() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final getCurrentUserUidResult = await _getCurrentUserUidUseCase();

    getCurrentUserUidResult.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (uid) async {
        final result = await _getUserUseCase(uid: uid);

        result.fold(
          (failure) {
            _updateState(_state.copyWith(
              isLoading: false,
              errorMessage: failure.message,
            ));
          },
          (user) {
            _updateState(_state.copyWith(
              isLoading: false,
              user: user,
            ));
          },
        );
      },
    );
  }

  Future<void> updateUser({required UserEntity userEntity}) async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _updateUserUseCase(userEntity: userEntity);

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (_) {
        _updateState(_state.copyWith(
          isLoading: false,
          user: userEntity,
          profileUpdated: true,
        ));
      },
    );
  }

  Future<void> getUserLikes() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final getCurrentUserUidResult = await _getCurrentUserUidUseCase();

    getCurrentUserUidResult.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (uid) async {
        final result = await _getUserLikesUseCase(uid: uid);

        result.fold(
          (failure) {
            _updateState(_state.copyWith(
              isLoading: false,
              errorMessage: failure.message,
            ));
          },
          (likes) {
            _updateState(_state.copyWith(
              isLoading: false,
              userLikes: likes,
            ));
          },
        );
      },
    );
  }

  Future<void> addUserLike({required String postId}) async {
    final result = await _addUserLikesUseCase(postId: postId);

    result.fold(
      (failure) {
        _updateState(_state.copyWith(errorMessage: failure.message));
      },
      (_) {
        final updatedLikes = List<String>.from(_state.userLikes)..add(postId);
        _updateState(_state.copyWith(userLikes: updatedLikes));
      },
    );
  }

  Future<void> removeUserLike({required String postId}) async {
    final result = await _removeUserLikeUseCase(postId: postId);

    result.fold(
      (failure) {
        _updateState(_state.copyWith(errorMessage: failure.message));
      },
      (_) {
        final updatedLikes = List<String>.from(_state.userLikes)..remove(postId);
        _updateState(_state.copyWith(userLikes: updatedLikes));
      },
    );
  }

  Future<void> updateUserProfileImage({required String imagePath}) async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _updateUserProfileImageUseCase(imagePath: imagePath);

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (imageUrl) {
        if (_state.user != null) {
          final updatedUser = _state.user!.copyWith(profileImageUrl: imageUrl);
          _updateState(_state.copyWith(
            isLoading: false,
            user: updatedUser,
            profileUpdated: true,
          ));
        }
      },
    );
  }

  Future<void> deleteUser() async {
    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    final result = await _deleteUserUseCase();

    result.fold(
      (failure) {
        _updateState(_state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (_) {
        _updateState(_state.copyWith(
          isLoading: false,
          user: null,
        ));
      },
    );
  }

  void clearError() {
    _updateState(_state.copyWith(errorMessage: null));
  }

  void resetProfileUpdated() {
    _updateState(_state.copyWith(profileUpdated: false));
  }
}