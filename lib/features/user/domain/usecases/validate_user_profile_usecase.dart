import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user_entity_enhanced.dart';
import '../value_objects/username.dart';
import '../value_objects/bio.dart';

class ValidateUserProfileUseCase {
  ValidateUserProfileUseCase();

  Either<Failure, Unit> call({
    required UserEntityEnhanced userEntity,
  }) {
    if (!userEntity.isValid) {
      return Left(Failure(message: userEntity.validationError!));
    }

    if (userEntity.username.value.toLowerCase().contains('admin') ||
        userEntity.username.value.toLowerCase().contains('root')) {
      return Left(Failure(message: 'Username cannot contain restricted words'));
    }

    if (userEntity.bio.value.contains('http://') && !userEntity.bio.value.contains('https://')) {
      return Left(Failure(message: 'Bio cannot contain insecure HTTP links'));
    }

    if (userEntity.isNewUser && userEntity.bio.characterCount > 100) {
      return Left(Failure(message: 'New users are limited to 100 characters in bio'));
    }

    return const Right(unit);
  }

  List<String> getProfileCompletionSuggestions(UserEntityEnhanced userEntity) {
    final suggestions = <String>[];

    if (!userEntity.hasProfileImage) {
      suggestions.add('Add a profile picture');
    }

    if (userEntity.bio.isEmpty) {
      suggestions.add('Write a bio to tell others about yourself');
    }

    if (!userEntity.hasBackgroundImage) {
      suggestions.add('Add a background image to personalize your profile');
    }

    if (userEntity.bio.characterCount < 20 && !userEntity.bio.isEmpty) {
      suggestions.add('Consider expanding your bio');
    }

    return suggestions;
  }

  double getProfileCompletionPercentage(UserEntityEnhanced userEntity) {
    int completedItems = 0;
    const int totalItems = 4;

    if (userEntity.hasProfileImage) completedItems++;
    if (!userEntity.bio.isEmpty) completedItems++;
    if (userEntity.hasBackgroundImage) completedItems++;
    if (userEntity.bio.characterCount >= 20) completedItems++;

    return (completedItems / totalItems) * 100;
  }
}