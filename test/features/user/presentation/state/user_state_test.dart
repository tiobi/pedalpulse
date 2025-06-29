import 'package:flutter_test/flutter_test.dart';
import 'package:pedalpulse/features/user/domain/entities/user_entity.dart';
import 'package:pedalpulse/features/user/presentation/state/user_state.dart';

void main() {
  group('UserState', () {
    final testUser = UserEntity.create(
      uid: 'uid123',
      email: 'test@example.com',
      username: 'testuser',
    );

    final testLikes = ['post1', 'post2', 'post3'];

    group('Factory constructors', () {
      test('should create initial state correctly', () {
        final state = UserState.initial();

        expect(state.currentUser, isNull);
        expect(state.isLoading, false);
        expect(state.isInitialized, false);
        expect(state.errorMessage, isNull);
        expect(state.successMessage, isNull);
        expect(state.userLikes, isNull);
        expect(state.isUpdatingProfile, false);
        expect(state.isUpdatingProfileImage, false);
      });

      test('should create loading state correctly', () {
        final state = UserState.loading();

        expect(state.currentUser, isNull);
        expect(state.isLoading, true);
        expect(state.isInitialized, false);
        expect(state.errorMessage, isNull);
        expect(state.successMessage, isNull);
        expect(state.userLikes, isNull);
        expect(state.isUpdatingProfile, false);
        expect(state.isUpdatingProfileImage, false);
      });

      test('should create loaded state correctly', () {
        final state = UserState.loaded(
          user: testUser,
          userLikes: testLikes,
        );

        expect(state.currentUser, testUser);
        expect(state.isLoading, false);
        expect(state.isInitialized, true);
        expect(state.errorMessage, isNull);
        expect(state.successMessage, isNull);
        expect(state.userLikes, testLikes);
        expect(state.isUpdatingProfile, false);
        expect(state.isUpdatingProfileImage, false);
      });

      test('should create loaded state with default empty likes', () {
        final state = UserState.loaded(user: testUser);

        expect(state.currentUser, testUser);
        expect(state.userLikes, []);
      });

      test('should create error state correctly', () {
        final state = UserState.error(
          errorMessage: 'Network error',
          currentUser: testUser,
          wasInitialized: true,
        );

        expect(state.currentUser, testUser);
        expect(state.isLoading, false);
        expect(state.isInitialized, true);
        expect(state.errorMessage, 'Network error');
        expect(state.successMessage, isNull);
        expect(state.userLikes, isNull);
        expect(state.isUpdatingProfile, false);
        expect(state.isUpdatingProfileImage, false);
      });

      test('should create error state with default values', () {
        final state = UserState.error(errorMessage: 'Some error');

        expect(state.currentUser, isNull);
        expect(state.isInitialized, false);
        expect(state.errorMessage, 'Some error');
      });

      test('should create updating state correctly', () {
        final state = UserState.updating(
          currentUser: testUser,
          isUpdatingProfile: true,
          isUpdatingProfileImage: false,
          userLikes: testLikes,
        );

        expect(state.currentUser, testUser);
        expect(state.isLoading, false);
        expect(state.isInitialized, true);
        expect(state.errorMessage, isNull);
        expect(state.successMessage, isNull);
        expect(state.userLikes, testLikes);
        expect(state.isUpdatingProfile, true);
        expect(state.isUpdatingProfileImage, false);
      });
    });

    group('Extensions', () {
      test('should correctly identify error state', () {
        final stateWithError = UserState.error(errorMessage: 'Error');
        final stateWithoutError = UserState.initial();

        expect(stateWithError.hasError, true);
        expect(stateWithoutError.hasError, false);
      });

      test('should correctly identify success state', () {
        final stateWithSuccess = UserState.loaded(user: testUser).copyWith(
          successMessage: 'Success!',
        );
        final stateWithoutSuccess = UserState.initial();

        expect(stateWithSuccess.hasSuccess, true);
        expect(stateWithoutSuccess.hasSuccess, false);
      });

      test('should correctly identify user presence', () {
        final stateWithUser = UserState.loaded(user: testUser);
        final stateWithoutUser = UserState.initial();

        expect(stateWithUser.hasUser, true);
        expect(stateWithoutUser.hasUser, false);
      });

      test('should correctly identify ready state', () {
        final readyState = UserState.loaded(user: testUser);
        final loadingState = UserState.loading();
        final initialState = UserState.initial();

        expect(readyState.isReady, true);
        expect(loadingState.isReady, false);
        expect(initialState.isReady, false);
      });

      test('should correctly identify when actions can be performed', () {
        final readyState = UserState.loaded(user: testUser);
        final loadingState = UserState.loading();
        final updatingProfileState = UserState.updating(
          currentUser: testUser,
          isUpdatingProfile: true,
          isUpdatingProfileImage: false,
        );
        final updatingImageState = UserState.updating(
          currentUser: testUser,
          isUpdatingProfile: false,
          isUpdatingProfileImage: true,
        );

        expect(readyState.canPerformActions, true);
        expect(loadingState.canPerformActions, false);
        expect(updatingProfileState.canPerformActions, false);
        expect(updatingImageState.canPerformActions, false);
      });

      test('should correctly identify update progress', () {
        final noUpdateState = UserState.loaded(user: testUser);
        final profileUpdateState = UserState.updating(
          currentUser: testUser,
          isUpdatingProfile: true,
          isUpdatingProfileImage: false,
        );
        final imageUpdateState = UserState.updating(
          currentUser: testUser,
          isUpdatingProfile: false,
          isUpdatingProfileImage: true,
        );
        final bothUpdateState = UserState.updating(
          currentUser: testUser,
          isUpdatingProfile: true,
          isUpdatingProfileImage: true,
        );

        expect(noUpdateState.isAnyUpdateInProgress, false);
        expect(profileUpdateState.isAnyUpdateInProgress, true);
        expect(imageUpdateState.isAnyUpdateInProgress, true);
        expect(bothUpdateState.isAnyUpdateInProgress, true);
      });
    });

    group('Immutability and copyWith', () {
      test('should support copyWith functionality', () {
        final original = UserState.initial();
        final updated = original.copyWith(
          isLoading: true,
          errorMessage: 'Test error',
          currentUser: testUser,
        );

        expect(updated.isLoading, true);
        expect(updated.errorMessage, 'Test error');
        expect(updated.currentUser, testUser);
        expect(updated.isInitialized, false); // Unchanged
        expect(original.isLoading, false); // Original unchanged
        expect(original.errorMessage, isNull); // Original unchanged
        expect(original.currentUser, isNull); // Original unchanged
      });

      test('should handle null values in copyWith', () {
        final stateWithUser = UserState.loaded(user: testUser);
        final clearedState = stateWithUser.copyWith(currentUser: null);

        expect(stateWithUser.currentUser, testUser);
        expect(clearedState.currentUser, isNull);
      });

      test('should update user likes correctly', () {
        final original = UserState.loaded(user: testUser, userLikes: ['post1']);
        final updated = original.copyWith(userLikes: ['post1', 'post2']);

        expect(original.userLikes, ['post1']);
        expect(updated.userLikes, ['post1', 'post2']);
      });
    });

    group('Equality and hashCode', () {
      test('should be equal when all properties are the same', () {
        final state1 = UserState.loaded(user: testUser, userLikes: testLikes);
        final state2 = UserState.loaded(user: testUser, userLikes: testLikes);

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when properties differ', () {
        final user2 = testUser.copyWith(username: 'different');
        final state1 = UserState.loaded(user: testUser);
        final state2 = UserState.loaded(user: user2);

        expect(state1, isNot(equals(state2)));
      });
    });

    group('JSON serialization', () {
      test('should serialize and deserialize correctly', () {
        final original = UserState.loaded(
          user: testUser,
          userLikes: testLikes,
        ).copyWith(successMessage: 'Test success');

        final json = original.toJson();
        final deserialized = UserState.fromJson(json);

        expect(deserialized.currentUser?.uid, original.currentUser?.uid);
        expect(deserialized.isLoading, original.isLoading);
        expect(deserialized.isInitialized, original.isInitialized);
        expect(deserialized.userLikes, original.userLikes);
        expect(deserialized.successMessage, original.successMessage);
        expect(deserialized.isUpdatingProfile, original.isUpdatingProfile);
        expect(deserialized.isUpdatingProfileImage, original.isUpdatingProfileImage);
      });

      test('should handle null values in JSON serialization', () {
        final original = UserState.initial();

        final json = original.toJson();
        final deserialized = UserState.fromJson(json);

        expect(deserialized.currentUser, isNull);
        expect(deserialized.errorMessage, isNull);
        expect(deserialized.successMessage, isNull);
        expect(deserialized.userLikes, isNull);
      });
    });

    group('State transitions', () {
      test('should transition from initial to loading', () {
        final initial = UserState.initial();
        final loading = UserState.loading();

        expect(initial.isInitialized, false);
        expect(initial.isLoading, false);
        expect(loading.isInitialized, false);
        expect(loading.isLoading, true);
      });

      test('should transition from loading to loaded', () {
        final loading = UserState.loading();
        final loaded = UserState.loaded(user: testUser);

        expect(loading.isLoading, true);
        expect(loading.currentUser, isNull);
        expect(loaded.isLoading, false);
        expect(loaded.currentUser, testUser);
        expect(loaded.isInitialized, true);
      });

      test('should transition from loaded to updating', () {
        final loaded = UserState.loaded(user: testUser);
        final updating = UserState.updating(
          currentUser: testUser,
          isUpdatingProfile: true,
          isUpdatingProfileImage: false,
        );

        expect(loaded.isUpdatingProfile, false);
        expect(loaded.isUpdatingProfileImage, false);
        expect(updating.isUpdatingProfile, true);
        expect(updating.isUpdatingProfileImage, false);
      });

      test('should handle error states properly', () {
        final loaded = UserState.loaded(user: testUser);
        final error = UserState.error(
          errorMessage: 'Something went wrong',
          currentUser: testUser,
          wasInitialized: true,
        );

        expect(loaded.hasError, false);
        expect(error.hasError, true);
        expect(error.currentUser, testUser); // User data preserved
        expect(error.isInitialized, true); // State preserved
      });
    });

    group('User interaction scenarios', () {
      test('should handle successful profile update', () {
        final initial = UserState.loaded(user: testUser);
        final updating = initial.copyWith(isUpdatingProfile: true);
        final updatedUser = testUser.copyWith(bio: 'New bio');
        final completed = updating.copyWith(
          currentUser: updatedUser,
          isUpdatingProfile: false,
          successMessage: 'Profile updated',
        );

        expect(initial.canPerformActions, true);
        expect(updating.canPerformActions, false);
        expect(completed.canPerformActions, true);
        expect(completed.currentUser?.bio, 'New bio');
        expect(completed.hasSuccess, true);
      });

      test('should handle like operations', () {
        final initial = UserState.loaded(user: testUser, userLikes: ['post1']);
        final withNewLike = initial.copyWith(userLikes: ['post1', 'post2']);
        final withRemovedLike = withNewLike.copyWith(userLikes: ['post2']);

        expect(initial.userLikes, ['post1']);
        expect(withNewLike.userLikes, ['post1', 'post2']);
        expect(withRemovedLike.userLikes, ['post2']);
      });
    });
  });
}