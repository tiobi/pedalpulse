import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:pedalpulse/features/user/domain/usecases/update_user_usecase_enhanced.dart';
import 'package:pedalpulse/features/user/domain/repositories/user_repository_new.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity_enhanced.dart';
import 'package:pedalpulse/features/user/domain/value_objects/username.dart';
import 'package:pedalpulse/features/user/domain/value_objects/bio.dart';
import 'package:pedalpulse/features/user/domain/value_objects/image_url.dart';
import 'package:pedalpulse/core/errors/user_failure.dart';

@GenerateMocks([UserRepositoryNew])
import 'update_user_usecase_enhanced_test.mocks.dart';

void main() {
  group('UpdateUserUseCaseEnhanced', () {
    late UpdateUserUseCaseEnhanced useCase;
    late MockUserRepositoryNew mockRepository;

    setUp(() {
      mockRepository = MockUserRepositoryNew();
      useCase = UpdateUserUseCaseEnhanced(repository: mockRepository);
    });

    group('Valid Updates', () {
      test('should update user successfully with valid data', () async {
        final userEntity = _createValidUser();
        
        when(mockRepository.updateUser(any))
            .thenAnswer((_) async => Right(unit));

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Right<UserFailure, Unit>>());
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (unit) => expect(unit, isA<Unit>()),
        );

        verify(mockRepository.updateUser(userEntity)).called(1);
      });

      test('should update user with minimum valid data', () async {
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('validuser'),
          bio: Bio(''),
          imageUrl: ImageUrl(''),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );
        
        when(mockRepository.updateUser(any))
            .thenAnswer((_) async => Right(unit));

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Right<UserFailure, Unit>>());
        verify(mockRepository.updateUser(userEntity)).called(1);
      });

      test('should update user with complete profile', () async {
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('completeuser'),
          bio: Bio('I am a complete user with full profile information'),
          imageUrl: ImageUrl('https://example.com/complete-avatar.jpg'),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );
        
        when(mockRepository.updateUser(any))
            .thenAnswer((_) async => Right(unit));

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Right<UserFailure, Unit>>());
        expect(userEntity.isProfileComplete, true);
        verify(mockRepository.updateUser(userEntity)).called(1);
      });
    });

    group('Domain Validation', () {
      test('should fail for invalid username', () async {
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('ab'), // Too short
          bio: Bio('Valid bio'),
          imageUrl: ImageUrl('https://example.com/avatar.jpg'),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Left<UserFailure, Unit>>());
        result.fold(
          (failure) {
            expect(failure, isA<UserFailure>());
            expect(failure.message, contains('Username must be at least 3 characters long'));
          },
          (unit) => fail('Expected failure but got success'),
        );

        verifyNever(mockRepository.updateUser(any));
      });

      test('should fail for invalid bio', () async {
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('validuser'),
          bio: Bio('a' * (Bio.maxLength + 1)), // Too long
          imageUrl: ImageUrl('https://example.com/avatar.jpg'),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Left<UserFailure, Unit>>());
        result.fold(
          (failure) {
            expect(failure, isA<UserFailure>());
            expect(failure.message, contains('Bio must be less than ${Bio.maxLength} characters long'));
          },
          (unit) => fail('Expected failure but got success'),
        );

        verifyNever(mockRepository.updateUser(any));
      });

      test('should fail for invalid image URL', () async {
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('validuser'),
          bio: Bio('Valid bio'),
          imageUrl: ImageUrl('http://insecure.com/avatar.jpg'), // Not HTTPS
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Left<UserFailure, Unit>>());
        result.fold(
          (failure) {
            expect(failure, isA<UserFailure>());
            expect(failure.message, contains('Image URL must use HTTPS for security'));
          },
          (unit) => fail('Expected failure but got success'),
        );

        verifyNever(mockRepository.updateUser(any));
      });

      test('should fail for multiple validation errors', () async {
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('ab'), // Too short
          bio: Bio('a' * (Bio.maxLength + 1)), // Too long
          imageUrl: ImageUrl('not-a-url'), // Invalid URL
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Left<UserFailure, Unit>>());
        result.fold(
          (failure) {
            expect(failure, isA<UserFailure>());
            expect(failure.message, contains('Username must be at least 3 characters long'));
            expect(failure.message, contains('Bio must be less than ${Bio.maxLength} characters long'));
            expect(failure.message, contains('Please enter a valid URL'));
          },
          (unit) => fail('Expected failure but got success'),
        );

        verifyNever(mockRepository.updateUser(any));
      });
    });

    group('Repository Failures', () {
      test('should handle user not found error', () async {
        final userEntity = _createValidUser();
        
        when(mockRepository.updateUser(any))
            .thenAnswer((_) async => Left(UserFailure('User not found')));

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Left<UserFailure, Unit>>());
        result.fold(
          (failure) => expect(failure.message, 'User not found'),
          (unit) => fail('Expected failure but got success'),
        );
      });

      test('should handle network errors', () async {
        final userEntity = _createValidUser();
        
        when(mockRepository.updateUser(any))
            .thenAnswer((_) async => Left(UserFailure('Network error')));

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Left<UserFailure, Unit>>());
        result.fold(
          (failure) => expect(failure.message, 'Network error'),
          (unit) => fail('Expected failure but got success'),
        );
      });

      test('should handle permission denied errors', () async {
        final userEntity = _createValidUser();
        
        when(mockRepository.updateUser(any))
            .thenAnswer((_) async => Left(UserFailure('Permission denied')));

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Left<UserFailure, Unit>>());
        result.fold(
          (failure) => expect(failure.message, 'Permission denied'),
          (unit) => fail('Expected failure but got success'),
        );
      });
    });

    group('Username Validation', () {
      test('should handle various valid usernames', () async {
        final validUsernames = [
          'user123',
          'guitar_player',
          'PedalCollector',
          'musician_2023',
          'a' * Username.maxLength,
        ];

        for (final usernameStr in validUsernames) {
          final userEntity = UserEntityEnhanced(
            uid: 'user123',
            email: 'test@example.com',
            username: Username(usernameStr),
            bio: Bio('Valid bio'),
            imageUrl: ImageUrl('https://example.com/avatar.jpg'),
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime.now(),
          );
          
          when(mockRepository.updateUser(any))
              .thenAnswer((_) async => Right(unit));

          final result = await useCase(UpdateUserParams(userEntity));

          expect(result, isA<Right<UserFailure, Unit>>(), 
                 reason: '$usernameStr should be valid');
        }
      });

      test('should reject invalid usernames', () async {
        final invalidUsernames = [
          'ab', // Too short
          'user with spaces',
          'user@name',
          'user-name',
          'a' * (Username.maxLength + 1), // Too long
        ];

        for (final usernameStr in invalidUsernames) {
          final userEntity = UserEntityEnhanced(
            uid: 'user123',
            email: 'test@example.com',
            username: Username(usernameStr),
            bio: Bio('Valid bio'),
            imageUrl: ImageUrl('https://example.com/avatar.jpg'),
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime.now(),
          );

          final result = await useCase(UpdateUserParams(userEntity));

          expect(result, isA<Left<UserFailure, Unit>>(), 
                 reason: '$usernameStr should be invalid');
        }

        verifyNever(mockRepository.updateUser(any));
      });
    });

    group('Bio Validation', () {
      test('should handle various valid bios', () async {
        final validBios = [
          '',
          'Short bio',
          'I love guitar pedals and making music!',
          'Bio with émojis 🎸🎵 and special characters!',
          'a' * Bio.maxLength,
        ];

        for (final bioStr in validBios) {
          final userEntity = UserEntityEnhanced(
            uid: 'user123',
            email: 'test@example.com',
            username: Username('validuser'),
            bio: Bio(bioStr),
            imageUrl: ImageUrl('https://example.com/avatar.jpg'),
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime.now(),
          );
          
          when(mockRepository.updateUser(any))
              .thenAnswer((_) async => Right(unit));

          final result = await useCase(UpdateUserParams(userEntity));

          expect(result, isA<Right<UserFailure, Unit>>(), 
                 reason: 'Bio of length ${bioStr.length} should be valid');
        }
      });

      test('should reject bios that are too long', () async {
        final longBio = 'a' * (Bio.maxLength + 1);
        final userEntity = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('validuser'),
          bio: Bio(longBio),
          imageUrl: ImageUrl('https://example.com/avatar.jpg'),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );

        final result = await useCase(UpdateUserParams(userEntity));

        expect(result, isA<Left<UserFailure, Unit>>());
        verifyNever(mockRepository.updateUser(any));
      });
    });

    group('Image URL Validation', () {
      test('should handle various valid image URLs', () async {
        final validUrls = [
          '',
          'https://example.com/avatar.jpg',
          'https://cdn.example.com/images/user123.png',
          'https://firebasestorage.googleapis.com/v0/b/project/image.jpg',
        ];

        for (final urlStr in validUrls) {
          final userEntity = UserEntityEnhanced(
            uid: 'user123',
            email: 'test@example.com',
            username: Username('validuser'),
            bio: Bio('Valid bio'),
            imageUrl: ImageUrl(urlStr),
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime.now(),
          );
          
          when(mockRepository.updateUser(any))
              .thenAnswer((_) async => Right(unit));

          final result = await useCase(UpdateUserParams(userEntity));

          expect(result, isA<Right<UserFailure, Unit>>(), 
                 reason: '$urlStr should be valid');
        }
      });

      test('should reject invalid image URLs', () async {
        final invalidUrls = [
          'http://insecure.com/avatar.jpg', // Not HTTPS
          'not-a-url',
          'ftp://example.com/image.jpg',
        ];

        for (final urlStr in invalidUrls) {
          final userEntity = UserEntityEnhanced(
            uid: 'user123',
            email: 'test@example.com',
            username: Username('validuser'),
            bio: Bio('Valid bio'),
            imageUrl: ImageUrl(urlStr),
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime.now(),
          );

          final result = await useCase(UpdateUserParams(userEntity));

          expect(result, isA<Left<UserFailure, Unit>>(), 
                 reason: '$urlStr should be invalid');
        }

        verifyNever(mockRepository.updateUser(any));
      });
    });

    group('Profile Completeness Scenarios', () {
      test('should update incomplete profiles', () async {
        final incompleteUser = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('newuser'),
          bio: Bio(''),
          imageUrl: ImageUrl(''),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );
        
        when(mockRepository.updateUser(any))
            .thenAnswer((_) async => Right(unit));

        final result = await useCase(UpdateUserParams(incompleteUser));

        expect(result, isA<Right<UserFailure, Unit>>());
        expect(incompleteUser.isProfileComplete, false);
        expect(incompleteUser.profileCompleteness, 20);
        verify(mockRepository.updateUser(incompleteUser)).called(1);
      });

      test('should update complete profiles', () async {
        final completeUser = UserEntityEnhanced(
          uid: 'user123',
          email: 'test@example.com',
          username: Username('completeuser'),
          bio: Bio('I am a complete user profile'),
          imageUrl: ImageUrl('https://example.com/complete.jpg'),
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime.now(),
        );
        
        when(mockRepository.updateUser(any))
            .thenAnswer((_) async => Right(unit));

        final result = await useCase(UpdateUserParams(completeUser));

        expect(result, isA<Right<UserFailure, Unit>>());
        expect(completeUser.isProfileComplete, true);
        expect(completeUser.profileCompleteness, 60);
        verify(mockRepository.updateUser(completeUser)).called(1);
      });
    });

    group('Real-world Update Scenarios', () {
      test('should handle typical profile updates', () async {
        final updateScenarios = [
          {
            'username': 'guitar_hero',
            'bio': 'Professional guitarist and pedal collector',
            'imageUrl': 'https://example.com/guitarist.jpg',
          },
          {
            'username': 'pedal_lover',
            'bio': 'Always searching for the perfect tone',
            'imageUrl': 'https://cdn.example.com/pedalboard.png',
          },
          {
            'username': 'musician_2023',
            'bio': 'Creating music with passion 🎸🎵',
            'imageUrl': 'https://storage.googleapis.com/music.jpg',
          },
        ];

        for (final scenario in updateScenarios) {
          final userEntity = UserEntityEnhanced(
            uid: 'user123',
            email: 'test@example.com',
            username: Username(scenario['username']!),
            bio: Bio(scenario['bio']!),
            imageUrl: ImageUrl(scenario['imageUrl']!),
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime.now(),
          );
          
          when(mockRepository.updateUser(any))
              .thenAnswer((_) async => Right(unit));

          final result = await useCase(UpdateUserParams(userEntity));

          expect(result, isA<Right<UserFailure, Unit>>(), 
                 reason: 'Scenario ${scenario['username']} should succeed');
          expect(userEntity.isValid, true);
        }
      });

      test('should reject invalid profile updates', () async {
        final invalidScenarios = [
          {
            'username': 'ab', // Too short
            'bio': 'Valid bio',
            'imageUrl': 'https://example.com/avatar.jpg',
          },
          {
            'username': 'validuser',
            'bio': 'a' * (Bio.maxLength + 1), // Too long
            'imageUrl': 'https://example.com/avatar.jpg',
          },
          {
            'username': 'validuser',
            'bio': 'Valid bio',
            'imageUrl': 'http://insecure.com/avatar.jpg', // Not HTTPS
          },
        ];

        for (final scenario in invalidScenarios) {
          final userEntity = UserEntityEnhanced(
            uid: 'user123',
            email: 'test@example.com',
            username: Username(scenario['username']!),
            bio: Bio(scenario['bio']!),
            imageUrl: ImageUrl(scenario['imageUrl']!),
            createdAt: DateTime(2023, 1, 1),
            updatedAt: DateTime.now(),
          );

          final result = await useCase(UpdateUserParams(userEntity));

          expect(result, isA<Left<UserFailure, Unit>>(), 
                 reason: 'Invalid scenario should fail');
        }

        verifyNever(mockRepository.updateUser(any));
      });
    });
  });
}

UserEntityEnhanced _createValidUser() {
  return UserEntityEnhanced(
    uid: 'user123',
    email: 'test@example.com',
    username: Username('validuser'),
    bio: Bio('I am a valid user'),
    imageUrl: ImageUrl('https://example.com/avatar.jpg'),
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime.now(),
  );
}