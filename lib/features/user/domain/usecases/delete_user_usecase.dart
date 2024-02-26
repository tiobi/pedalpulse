import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/user/domain/repositories/user_repository.dart';

import '../../../../core/errors/failure.dart';

class DeleteUserUseCase {
  final UserRepository repository;

  DeleteUserUseCase({required this.repository});

  Future<Either<Failure, Unit>> call({required String uid}) async {
    return await repository.deleteUser(uid: uid);
  }
}
