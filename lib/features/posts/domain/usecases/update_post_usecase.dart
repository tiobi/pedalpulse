import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';
import 'create_post_usecase.dart';

class UpdatePostUseCase {
  final PostRepository repository;

  UpdatePostUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required PostEntity post,
    String? title,
    String? description,
    List<String>? imageUrls,
    List<String>? pedalUids,
  }) async {
    final updatedTitle = title?.trim() ?? post.title;
    final updatedDescription = description?.trim() ?? post.description;
    final updatedImageUrls = imageUrls ?? post.imageUrls;
    final updatedPedalUids = pedalUids ?? post.pedalUids;

    if (updatedTitle.isEmpty) {
      return Left(ValidationFailure(message: 'Title cannot be empty'));
    }

    if (updatedDescription.isEmpty) {
      return Left(ValidationFailure(message: 'Description cannot be empty'));
    }

    if (updatedTitle.length > 100) {
      return Left(ValidationFailure(message: 'Title cannot exceed 100 characters'));
    }

    if (updatedDescription.length > 5000) {
      return Left(ValidationFailure(message: 'Description cannot exceed 5000 characters'));
    }

    if (updatedImageUrls.length > 5) {
      return Left(ValidationFailure(message: 'Cannot upload more than 5 images'));
    }

    final updatedPost = post.copyWith(
      title: updatedTitle,
      description: updatedDescription,
      imageUrls: updatedImageUrls,
      pedalUids: updatedPedalUids,
      updatedAt: DateTime.now(),
    );

    return repository.updatePost(post: updatedPost);
  }
}