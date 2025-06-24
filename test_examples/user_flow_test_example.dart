import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import '../lib/features/user/domain/entities/user_entity_enhanced.dart';
import '../lib/features/user/domain/value_objects/username.dart';
import '../lib/features/user/domain/value_objects/bio.dart';
import '../lib/features/user/domain/value_objects/image_url.dart';
import '../lib/features/user/domain/usecases/update_user_usecase_enhanced.dart';
import '../lib/features/user/domain/usecases/validate_user_profile_usecase.dart';
import '../lib/features/user/presentation/state/user_state.dart';
import '../lib/features/auth/domain/value_objects/email.dart';
import '../lib/core/errors/failure.dart';

class MockUserRepositoryNew extends Mock {}

void main() {
  group('User Flow Tests', () {
    group('User Value Objects Validation', () {
      test('should validate username correctly', () {
        final username = Username('validuser');
        expect(username.isValid, true);
        expect(username.error, null);
      });

      test('should invalidate short username', () {
        final username = Username('ab');
        expect(username.isValid, false);
        expect(username.error, contains('at least 3 characters'));
      });

      test('should invalidate username with special characters', () {
        final username = Username('user@name');
        expect(username.isValid, false);
        expect(username.error, contains('letters, numbers, and underscores'));
      });

      test('should validate bio correctly', () {
        final bio = Bio('This is a valid bio');
        expect(bio.isValid, true);
        expect(bio.error, null);
        expect(bio.isEmpty, false);
      });

      test('should invalidate overly long bio', () {
        final longBio = 'a' * 501;
        final bio = Bio(longBio);
        expect(bio.isValid, false);
        expect(bio.error, contains('less than 500 characters'));
      });

      test('should validate image URL correctly', () {
        final imageUrl = ImageUrl('https://example.com/image.jpg');
        expect(imageUrl.isValid, true);
        expect(imageUrl.isHttps, true);
        expect(imageUrl.isEmpty, false);
      });

      test('should handle empty image URL', () {
        final imageUrl = ImageUrl('');
        expect(imageUrl.isValid, true);
        expect(imageUrl.isEmpty, true);
      });
    });

    group('Enhanced User Entity', () {
      test('should create valid user entity', () {
        final userEntity = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
          bio: 'I love guitar pedals!',
        );

        expect(userEntity.isValid, true);
        expect(userEntity.validationError, null);
        expect(userEntity.isNewUser, true);
      });

      test('should reject invalid user entity', () {
        final userEntity = UserEntityEnhanced.create(
          uid: '',
          username: 'ab',
          email: 'invalid-email',
          bio: '',
        );

        expect(userEntity.isValid, false);
        expect(userEntity.validationError, isNotNull);
      });

      test('should detect profile completion status', () {
        final incompleteUser = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
        );

        final completeUser = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
          profileImageUrl: 'https://example.com/profile.jpg',
          backgroundImageUrl: 'https://example.com/bg.jpg',
          bio: 'A detailed bio about the user',
        );

        expect(incompleteUser.hasProfileImage, false);
        expect(incompleteUser.hasBackgroundImage, false);
        
        expect(completeUser.hasProfileImage, true);
        expect(completeUser.hasBackgroundImage, true);
      });

      test('should calculate account age correctly', () {
        final oldUser = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
          joinedAt: DateTime.now().subtract(const Duration(days: 30)),
        );

        expect(oldUser.isNewUser, false);
        expect(oldUser.accountAge.inDays, greaterThan(20));
      });
    });

    group('Update User Use Case', () {
      test('should update user with valid data', () async {
        final repository = MockUserRepositoryNew();
        final useCase = UpdateUserUseCaseEnhanced(repository: repository);
        
        final userEntity = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
          bio: 'Updated bio',
        );

        when(repository.updateUser(userEntity: any))
            .thenAnswer((_) async => Right(userEntity.toModel().toEntity()));

        final result = await useCase(userEntity: userEntity);

        expect(result.isRight(), true);
        verify(repository.updateUser(userEntity: any));
      });

      test('should reject invalid user data', () async {
        final repository = MockUserRepositoryNew();
        final useCase = UpdateUserUseCaseEnhanced(repository: repository);
        
        final userEntity = UserEntityEnhanced.create(
          uid: '',
          username: 'ab',
          email: 'invalid-email',
        );

        final result = await useCase(userEntity: userEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, isNotNull),
          (_) => fail('Should have failed'),
        );
      });
    });

    group('Validate User Profile Use Case', () {
      late ValidateUserProfileUseCase validateProfileUseCase;

      setUp(() {
        validateProfileUseCase = ValidateUserProfileUseCase();
      });

      test('should validate correct profile', () {
        final userEntity = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
          bio: 'I love guitar pedals!',
        );

        final result = validateProfileUseCase(userEntity: userEntity);

        expect(result.isRight(), true);
      });

      test('should reject restricted usernames', () {
        final userEntity = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'admin123',
          email: 'test@example.com',
        );

        final result = validateProfileUseCase(userEntity: userEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('restricted words')),
          (_) => fail('Should have failed'),
        );
      });

      test('should reject insecure HTTP links in bio', () {
        final userEntity = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
          bio: 'Check out my site: http://example.com',
        );

        final result = validateProfileUseCase(userEntity: userEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('insecure HTTP')),
          (_) => fail('Should have failed'),
        );
      });

      test('should limit new user bio length', () {
        final userEntity = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
          bio: 'a' * 150,
          joinedAt: DateTime.now(),
        );

        final result = validateProfileUseCase(userEntity: userEntity);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('limited to 100')),
          (_) => fail('Should have failed'),
        );
      });

      test('should provide profile completion suggestions', () {
        final incompleteUser = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
        );

        final suggestions = validateProfileUseCase
            .getProfileCompletionSuggestions(incompleteUser);

        expect(suggestions.length, greaterThan(0));
        expect(suggestions.any((s) => s.contains('profile picture')), true);
        expect(suggestions.any((s) => s.contains('bio')), true);
      });

      test('should calculate profile completion percentage', () {
        final incompleteUser = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
        );

        final completeUser = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
          profileImageUrl: 'https://example.com/profile.jpg',
          backgroundImageUrl: 'https://example.com/bg.jpg',
          bio: 'A detailed bio about the user and their interests',
        );

        final incompletePercentage = validateProfileUseCase
            .getProfileCompletionPercentage(incompleteUser);
        final completePercentage = validateProfileUseCase
            .getProfileCompletionPercentage(completeUser);

        expect(incompletePercentage, lessThan(100));
        expect(completePercentage, equals(100));
      });
    });

    group('User State Management', () {
      test('should initialize with correct default state', () {
        const userState = UserState();

        expect(userState.isLoading, false);
        expect(userState.user, null);
        expect(userState.userLikes, isEmpty);
        expect(userState.errorMessage, null);
        expect(userState.profileUpdated, false);
      });

      test('should update user state correctly', () {
        const initialState = UserState();
        final userEntity = UserEntityEnhanced.create(
          uid: 'test-uid',
          username: 'testuser',
          email: 'test@example.com',
        ).toModel().toEntity();

        final updatedState = initialState.copyWith(
          user: userEntity,
          profileUpdated: true,
        );

        expect(updatedState.user, equals(userEntity));
        expect(updatedState.profileUpdated, true);
      });

      test('should handle user likes correctly', () {
        const initialState = UserState();
        final likesState = initialState.copyWith(
          userLikes: ['post1', 'post2', 'post3'],
        );

        expect(likesState.userLikes.length, 3);
        expect(likesState.userLikes, contains('post1'));
      });
    });
  });
}

class TestUserFlow {
  static Future<void> runFullUserFlow() async {
    print('🧪 Testing Full User Flow...');
    
    print('1. Creating valid user entity...');
    final userEntity = UserEntityEnhanced.create(
      uid: 'test-uid-123',
      username: 'guitarlover',
      email: 'user@example.com',
      bio: 'I collect vintage guitar pedals and love creating music!',
      profileImageUrl: 'https://example.com/profile.jpg',
    );
    
    assert(userEntity.isValid, 'User entity should be valid');
    print('✅ User entity created and validated');
    
    print('2. Testing profile completion...');
    final validateUseCase = ValidateUserProfileUseCase();
    final validationResult = validateUseCase(userEntity: userEntity);
    assert(validationResult.isRight(), 'Profile should be valid');
    
    final completionPercentage = validateUseCase
        .getProfileCompletionPercentage(userEntity);
    print('📊 Profile completion: ${completionPercentage.toStringAsFixed(1)}%');
    
    print('3. Testing username validation...');
    assert(userEntity.username.isValid, 'Username should be valid');
    assert(userEntity.username.hasValidLength, 'Username length should be valid');
    assert(userEntity.username.hasValidCharacters, 'Username characters should be valid');
    print('✅ Username validation passed');
    
    print('4. Testing bio validation...');
    assert(userEntity.bio.isValid, 'Bio should be valid');
    assert(!userEntity.bio.isEmpty, 'Bio should not be empty');
    assert(userEntity.bio.characterCount <= Bio.maxLength, 'Bio should be within limits');
    print('✅ Bio validation passed');
    
    print('5. Testing profile features...');
    assert(userEntity.hasProfileImage, 'Should have profile image');
    assert(userEntity.isNewUser, 'Should be a new user');
    print('✅ Profile features working correctly');
    
    print('6. Testing invalid user rejection...');
    final invalidUser = UserEntityEnhanced.create(
      uid: '',
      username: 'admin',
      email: 'bad-email',
      bio: 'Check out http://insecure-site.com',
    );
    
    assert(!invalidUser.isValid, 'Invalid user should be rejected');
    
    final invalidValidation = validateUseCase(userEntity: invalidUser);
    if (invalidUser.isValid) {
      assert(invalidValidation.isLeft(), 'Should fail business rules validation');
    }
    print('✅ Invalid user properly rejected');
    
    print('7. Testing profile suggestions...');
    final incompleteUser = UserEntityEnhanced.create(
      uid: 'test-uid',
      username: 'newuser',
      email: 'new@example.com',
    );
    
    final suggestions = validateUseCase.getProfileCompletionSuggestions(incompleteUser);
    assert(suggestions.isNotEmpty, 'Should have completion suggestions');
    print('💡 Suggestions: ${suggestions.join(', ')}');
    
    print('🎉 All user flow tests passed!');
  }
}