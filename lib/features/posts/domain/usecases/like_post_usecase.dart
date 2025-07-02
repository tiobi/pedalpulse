import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/post_repository.dart';
import 'create_post_usecase.dart';

class LikePostUseCase {
  final PostRepository repository;

  LikePostUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required String postUid,
    required String userUid,
  }) async {
    if (postUid.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Post ID cannot be empty'));
    }

    if (userUid.trim().isEmpty) {
      return Left(ValidationFailure(message: 'User ID cannot be empty'));
    }

    final postResult = await repository.getPostByUid(postUid: postUid);
    
    return postResult.fold(
      (failure) => Left(failure),
      (post) {
        if (post.likes.contains(userUid)) {
          return Left(ValidationFailure(message: 'Post already liked'));
        }
        
        return repository.likePost(postUid: postUid, userUid: userUid);
      },
    );
  }
}