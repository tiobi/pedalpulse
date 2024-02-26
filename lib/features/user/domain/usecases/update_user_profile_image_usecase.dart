import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfileImageUseCase {
  final UserRepository repository;

  UpdateUserProfileImageUseCase({
    required this.repository,
  });

  Future<Either<Failure, Unit>> call({
    required String uid,
    XFile? profileImage,
    XFile? coverImage,
  }) async {
    return await repository.updateUserProfileImage(
      uid: uid,
      profileImage: profileImage,
      coverImage: coverImage,
    );
  }
}
