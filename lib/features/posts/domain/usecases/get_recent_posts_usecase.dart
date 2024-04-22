import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetRecentPostsUseCase {
  final PostRepository repository;

  GetRecentPostsUseCase({required this.repository});

  Future<Either<Failure, List<PostEntity>>> call({int limit = 3}) async {
    return repository.getRecentPosts(limit: limit);
  }
}
