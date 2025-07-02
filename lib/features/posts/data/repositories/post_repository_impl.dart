import 'package:dartz/dartz.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/firestore_database_failure.dart';
import 'package:pedalpulse/features/posts/data/datasources/post_firestore_datasource.dart';
import 'package:pedalpulse/features/posts/data/models/post_model.dart';
import 'package:pedalpulse/features/posts/domain/entities/post_entity.dart';
import 'package:pedalpulse/features/posts/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostFirestoreDataSource dataSource;

  PostRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<PostEntity>>> getPopularPosts(
      {int limit = 3}) async {
    try {
      final List<PostModel> postModels =
          await dataSource.getPopularPosts(limit: limit);

      final List<PostEntity> postEntities =
          postModels.map((e) => e.toEntity()).toList();

      return Right(postEntities);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getRecentPosts(
      {int limit = 3}) async {
    try {
      final List<PostModel> postModels =
          await dataSource.getRecentPosts(limit: limit);

      final List<PostEntity> postEntities =
          postModels.map((e) => e.toEntity()).toList();

      return Right(postEntities);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getFeedPosts(
      {int limit = 10}) async {
    try {
      final List<PostModel> postModels =
          await dataSource.getFeedPosts(limit: limit);

      final List<PostEntity> postEntities =
          postModels.map((e) => e.toEntity()).toList();

      return Right(postEntities);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPostsWithPedal({
    required String pedalUid,
    int limit = 10,
  }) async {
    try {
      final List<PostModel> postModels = await dataSource.getPostsWithPedal(
        pedalUid: pedalUid,
        limit: limit,
      );

      final List<PostEntity> postEntities =
          postModels.map((e) => e.toEntity()).toList();

      return Right(postEntities);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostByUid(
      {required String postUid}) async {
    try {
      final PostModel postModel =
          await dataSource.getPostByUid(postUid: postUid);

      final PostEntity postEntity = postModel.toEntity();

      return Right(postEntity);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createPost({required PostEntity post}) async {
    try {
      final PostModel postModel = PostModel(
        uid: post.uid,
        userUid: post.userUid,
        username: post.username,
        userProfileImageUrl: post.userProfileImageUrl,
        imageUrls: post.imageUrls,
        title: post.title,
        description: post.description,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        likes: post.likes,
        reports: post.reports,
        likesCount: post.likesCount,
        commentsCount: post.commentsCount,
        pedalList: [],
        pedalUids: post.pedalUids,
        views: post.views,
      );

      final String postId = await dataSource.createPost(post: postModel);
      return Right(postId);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePost({required PostEntity post}) async {
    try {
      final PostModel postModel = PostModel(
        uid: post.uid,
        userUid: post.userUid,
        username: post.username,
        userProfileImageUrl: post.userProfileImageUrl,
        imageUrls: post.imageUrls,
        title: post.title,
        description: post.description,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        likes: post.likes,
        reports: post.reports,
        likesCount: post.likesCount,
        commentsCount: post.commentsCount,
        pedalList: [],
        pedalUids: post.pedalUids,
        views: post.views,
      );

      await dataSource.updatePost(post: postModel);
      return const Right(unit);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost({required String postUid}) async {
    try {
      await dataSource.deletePost(postUid: postUid);
      return const Right(unit);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> likePost({
    required String postUid,
    required String userUid,
  }) async {
    try {
      await dataSource.likePost(postUid: postUid, userUid: userUid);
      return const Right(unit);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> unlikePost({
    required String postUid,
    required String userUid,
  }) async {
    try {
      await dataSource.unlikePost(postUid: postUid, userUid: userUid);
      return const Right(unit);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImages({
    required List<String> imagePaths,
  }) async {
    try {
      final List<String> downloadUrls =
          await dataSource.uploadImages(imagePaths: imagePaths);
      return Right(downloadUrls);
    } catch (e) {
      return Left(FirestoreFailure(message: e.toString()));
    }
  }
}
