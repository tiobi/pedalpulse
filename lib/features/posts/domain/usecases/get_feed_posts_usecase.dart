import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/posts/domain/entities/post_entity.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/post_repository.dart';

class GetFeedPostsUseCase {
  final PostRepository postsRepository;

  GetFeedPostsUseCase({
    required this.postsRepository,
  });

  Future<Either<Failure, List<PostEntity>>> call() async {
    return await postsRepository.getFeedPosts();
  }
}
