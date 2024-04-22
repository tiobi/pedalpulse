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
}
