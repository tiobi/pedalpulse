import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/post_repository.dart';
import 'create_post_usecase.dart';

class UploadImagesUseCase {
  final PostRepository repository;

  UploadImagesUseCase({required this.repository});

  Future<Either<Failure, List<String>>> call({
    required List<String> imagePaths,
  }) async {
    if (imagePaths.isEmpty) {
      return Left(ValidationFailure(message: 'No images selected'));
    }

    if (imagePaths.length > 5) {
      return Left(ValidationFailure(message: 'Cannot upload more than 5 images'));
    }

    for (final path in imagePaths) {
      if (path.trim().isEmpty) {
        return Left(ValidationFailure(message: 'Invalid image path'));
      }
    }

    return repository.uploadImages(imagePaths: imagePaths);
  }
}