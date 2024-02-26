import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/user_repository.dart';

class GetUserLikesUseCase {
  final UserRepository repository;

  GetUserLikesUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<String>>> call({
    required String userUid,
  }) async {
    return repository.getUserLikes(userUid: userUid);
  }
}
