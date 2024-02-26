import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/user_repository.dart';

class RemoveUserLikeUseCase {
  final UserRepository repository;

  RemoveUserLikeUseCase({
    required this.repository,
  });

  Future<Either<Failure, Unit>> call({
    required String userUid,
    required String postUid,
  }) async {
    return repository.removeUserLike(
      userUid: userUid,
      postUid: postUid,
    );
  }
}
