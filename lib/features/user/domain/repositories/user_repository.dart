import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../auth/domain/entities/auth_entity.dart';
import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> getUserDetails({
    required AuthEntity authEntity,
  });
}
