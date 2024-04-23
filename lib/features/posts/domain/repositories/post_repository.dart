import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPopularPosts({int limit = 3});

  Future<Either<Failure, List<PostEntity>>> getRecentPosts({int limit = 3});

  Future<Either<Failure, List<PostEntity>>> getFeedPosts();
}
