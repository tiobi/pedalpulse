import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostsWithPedalUseCase {
  final PostRepository repository;

  GetPostsWithPedalUseCase({required this.repository});

  Future<Either<Failure, List<PostEntity>>> call(
      {required String pedalUid, int limit = 10}) async {
    return repository.getPostsWithPedal(
      pedalUid: pedalUid,
      limit: limit,
    );
  }
}
