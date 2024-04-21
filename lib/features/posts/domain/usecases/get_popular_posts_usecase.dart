import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPopularPostsUseCase {
  final PostRepository repository;

  GetPopularPostsUseCase({required this.repository});

  Future<Either<Failure, List<PostEntity>>> call() async {
    return repository.getPopularPosts();
  }
}
