import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPopularPosts({int limit = 3});

  Future<Either<Failure, List<PostEntity>>> getRecentPosts({int limit = 3});

  Future<Either<Failure, List<PostEntity>>> getFeedPosts();

  Future<Either<Failure, List<PostEntity>>> getPostsWithPedal({
    required String pedalUid,
    int limit = 10,
  });

  Future<Either<Failure, PostEntity>> getPostByUid({
    required String postUid,
  });
}
