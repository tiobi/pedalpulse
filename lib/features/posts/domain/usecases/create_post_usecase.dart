import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository repository;

  CreatePostUseCase({required this.repository});

  Future<Either<Failure, String>> call({
    required String userUid,
    required String username,
    required String userProfileImageUrl,
    required String title,
    required String description,
    required List<String> imageUrls,
    required List<String> pedalUids,
  }) async {
    if (title.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Title cannot be empty'));
    }

    if (description.trim().isEmpty) {
      return Left(ValidationFailure(message: 'Description cannot be empty'));
    }

    if (title.length > 100) {
      return Left(ValidationFailure(message: 'Title cannot exceed 100 characters'));
    }

    if (description.length > 5000) {
      return Left(ValidationFailure(message: 'Description cannot exceed 5000 characters'));
    }

    if (imageUrls.length > 5) {
      return Left(ValidationFailure(message: 'Cannot upload more than 5 images'));
    }

    final post = PostEntity(
      uid: '',
      userUid: userUid,
      username: username,
      userProfileImageUrl: userProfileImageUrl,
      title: title.trim(),
      description: description.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrls: imageUrls,
      likes: [],
      reports: [],
      pedalList: [],
      pedalUids: pedalUids,
      likesCount: 0,
      commentsCount: 0,
      views: 0,
    );

    return repository.createPost(post: post);
  }
}

class ValidationFailure extends Failure {
  ValidationFailure({required String message}) : super(message: message);
}