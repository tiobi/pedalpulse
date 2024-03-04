import 'package:flutter/material.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity.dart';
import 'package:pedalpulse/features/user/domain/usecases/add_user_likes_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/delete_user_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/get_user_likes_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/get_user_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/remove_user_like_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/update_user_profile_image_usecase.dart';
import 'package:pedalpulse/features/user/domain/usecases/update_user_usecase.dart';

class UserProvider extends ChangeNotifier {
  UserEntity? user;
  bool isLoading = false;

  GetUserUseCase getUserUseCase;
  UpdateUserUseCase updateUserUseCase;
  GetUserLikesUseCase getUserLikesUseCase;
  AddUserLikesUseCase addUserLikesUseCase;
  RemoveUserLikeUseCase removeUserLikeUseCase;
  DeleteUserUseCase deleteUserUseCase;
  UpdateUserProfileImageUseCase updateUserProfileImageUseCase;

  UserProvider({
    required this.getUserUseCase,
    required this.updateUserUseCase,
    required this.getUserLikesUseCase,
    required this.addUserLikesUseCase,
    required this.removeUserLikeUseCase,
    required this.deleteUserUseCase,
    required this.updateUserProfileImageUseCase,
  });

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
