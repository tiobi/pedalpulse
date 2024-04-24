import 'package:dartz/dartz.dart';
import 'package:pedalpulse/core/errors/failure.dart';

import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostByUidUseCase {
  final PostRepository repository;

  GetPostByUidUseCase({required this.repository});

  Future<Either<Failure, PostEntity>> call({required String postUid}) async {
    return repository.getPostByUid(postUid: postUid);
  }
}
