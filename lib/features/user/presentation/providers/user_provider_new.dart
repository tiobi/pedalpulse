import 'package:flutter/material.dart';
import '../../../../core/common/widgets/snack_bar_widget.dart';
import '../../domain/entities/user_entity.dart';
import '../view_models/user_view_model.dart';
import '../state/user_state.dart';

class UserProviderNew extends ChangeNotifier {
  final UserViewModel _userViewModel;

  UserProviderNew({required UserViewModel userViewModel}) : _userViewModel = userViewModel {
    _userViewModel.addListener(_onViewModelChange);
  }

  UserState get state => _userViewModel.state;

  void _onViewModelChange() {
    notifyListeners();
  }

  Future<void> getUser({BuildContext? context}) async {
    await _userViewModel.getUser();

    if (_userViewModel.state.errorMessage != null && context != null) {
      CustomSnackBar.showErrorSnackBar(context, _userViewModel.state.errorMessage!);
    }
  }

  Future<void> updateUser({
    required UserEntity userEntity,
    BuildContext? context,
  }) async {
    await _userViewModel.updateUser(userEntity: userEntity);

    if (_userViewModel.state.errorMessage != null && context != null) {
      CustomSnackBar.showErrorSnackBar(context, _userViewModel.state.errorMessage!);
    } else if (_userViewModel.state.profileUpdated && context != null) {
      CustomSnackBar.showSuccessSnackBar(context, 'Profile updated successfully');
      _userViewModel.resetProfileUpdated();
    }
  }

  Future<void> getUserLikes({BuildContext? context}) async {
    await _userViewModel.getUserLikes();

    if (_userViewModel.state.errorMessage != null && context != null) {
      CustomSnackBar.showErrorSnackBar(context, _userViewModel.state.errorMessage!);
    }
  }

  Future<void> addUserLike({
    required String postId,
    BuildContext? context,
  }) async {
    await _userViewModel.addUserLike(postId: postId);

    if (_userViewModel.state.errorMessage != null && context != null) {
      CustomSnackBar.showErrorSnackBar(context, _userViewModel.state.errorMessage!);
    }
  }

  Future<void> removeUserLike({
    required String postId,
    BuildContext? context,
  }) async {
    await _userViewModel.removeUserLike(postId: postId);

    if (_userViewModel.state.errorMessage != null && context != null) {
      CustomSnackBar.showErrorSnackBar(context, _userViewModel.state.errorMessage!);
    }
  }

  Future<void> updateUserProfileImage({
    required String imagePath,
    BuildContext? context,
  }) async {
    await _userViewModel.updateUserProfileImage(imagePath: imagePath);

    if (_userViewModel.state.errorMessage != null && context != null) {
      CustomSnackBar.showErrorSnackBar(context, _userViewModel.state.errorMessage!);
    } else if (_userViewModel.state.profileUpdated && context != null) {
      CustomSnackBar.showSuccessSnackBar(context, 'Profile image updated successfully');
      _userViewModel.resetProfileUpdated();
    }
  }

  Future<void> deleteUser({BuildContext? context}) async {
    await _userViewModel.deleteUser();

    if (_userViewModel.state.errorMessage != null && context != null) {
      CustomSnackBar.showErrorSnackBar(context, _userViewModel.state.errorMessage!);
    } else if (_userViewModel.state.user == null && context != null) {
      CustomSnackBar.showSuccessSnackBar(context, 'Account deleted successfully');
    }
  }

  void clearError() {
    _userViewModel.clearError();
  }

  @override
  void dispose() {
    _userViewModel.removeListener(_onViewModelChange);
    super.dispose();
  }
}