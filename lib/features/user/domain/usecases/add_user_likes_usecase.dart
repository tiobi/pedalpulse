import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/user_repository.dart';

class AddUserLikesUseCase {
  final UserRepository repository;

  AddUserLikesUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(
      {required String userUid, required String postUid}) async {
    return await repository.addUserLike(userUid: userUid, postUid: postUid);
  }
}
