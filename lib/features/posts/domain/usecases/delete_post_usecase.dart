import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/post_repository.dart';
import 'create_post_usecase.dart';

class DeletePostUseCase {
  final PostRepository repository;

  DeletePostUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required String postUid,
    required String currentUserUid,
  }) async {
    if (postUid.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Post ID cannot be empty'));
    }

    if (currentUserUid.trim().isEmpty) {
      return Left(ValidationFailure(message: 'User ID cannot be empty'));
    }

    final postResult = await repository.getPostByUid(postUid: postUid);
    
    return postResult.fold(
      (failure) => Left(failure),
      (post) {
        if (post.userUid != currentUserUid) {
          return Left(ValidationFailure(message: 'You can only delete your own posts'));
        }
        
        return repository.deletePost(postUid: postUid);
      },
    );
  }
}