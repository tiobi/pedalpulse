import 'package:pedalpulse/features/user/domain/repositories/user_repository.dart';

class GetUserPostsUseCase {
  final UserRepository repository;

  GetUserPostsUseCase({
    required this.repository,
  });

  // Future<Either<Failure, List<PostEntity>>> call() async {}
}
