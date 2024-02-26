import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedalpulse/core/errors/failure.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';
import 'package:pedalpulse/features/user/domain/usecases/update_user_profile_image_usecase.dart';

import '../../../../mocks/user/mock_user_repository.mocks.dart';

void main() {
  late UpdateUserProfileImageUseCase useCase;
  late MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
    useCase = UpdateUserProfileImageUseCase(repository: repository);
  });

  final Failure failure = UserFailure(message: 'User Failure');

  const String tUserUid = 'user-uid';
  final XFile tProfileImage = XFile('image');
  final XFile tCoverImage = XFile('image');

  const XFile? tNullProfileImage = null;
  const XFile? tNullCoverImage = null;
}
