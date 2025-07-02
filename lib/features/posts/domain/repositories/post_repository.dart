import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPopularPosts({int limit = 3});

  Future<Either<Failure, List<PostEntity>>> getRecentPosts({int limit = 3});

  Future<Either<Failure, List<PostEntity>>> getFeedPosts({int limit = 10});

  Future<Either<Failure, List<PostEntity>>> getPostsWithPedal({
    required String pedalUid,
    int limit = 10,
  });

  Future<Either<Failure, PostEntity>> getPostByUid({
    required String postUid,
  });

  Future<Either<Failure, String>> createPost({
    required PostEntity post,
  });

  Future<Either<Failure, Unit>> updatePost({
    required PostEntity post,
  });

  Future<Either<Failure, Unit>> deletePost({
    required String postUid,
  });

  Future<Either<Failure, Unit>> likePost({
    required String postUid,
    required String userUid,
  });

  Future<Either<Failure, Unit>> unlikePost({
    required String postUid,
    required String userUid,
  });

  Future<Either<Failure, List<String>>> uploadImages({
    required List<String> imagePaths,
  });
}
