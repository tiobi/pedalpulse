import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../models/user_model.dart';
import '../services/firebase_firestore_service.dart';
import '../services/firebase_storage_service.dart';

abstract class UserDataSourceNew {
  Future<UserModel> getUser({
    required String uid,
  });

  Future<UserModel> updateUser({
    required UserModel userModel,
  });

  Future<List<String>> getUserLikes({
    required String userUid,
  });

  Future<Unit> addUserLike({
    required String userUid,
    required String postUid,
  });

  Future<Unit> removeUserLike({
    required String userUid,
    required String postUid,
  });

  Future<Unit> deleteUser({
    required String uid,
  });

  Future<String> updateUserProfileImage({
    required String uid,
    required XFile profileImage,
  });

  Future<String> updateUserCoverImage({
    required String uid,
    required XFile coverImage,
  });

  Stream<UserModel> getUserStream({
    required String uid,
  });
}

class UserDataSourceNewImpl implements UserDataSourceNew {
  final FirebaseFirestoreService _firestoreService;
  final FirebaseStorageService _storageService;

  UserDataSourceNewImpl({
    required FirebaseFirestoreService firestoreService,
    required FirebaseStorageService storageService,
  })  : _firestoreService = firestoreService,
        _storageService = storageService;

  @override
  Future<UserModel> getUser({required String uid}) async {
    try {
      final doc = await _firestoreService.getUserDocument(uid: uid);
      
      if (!doc.exists || doc.data() == null) {
        throw Exception('User not found');
      }
      
      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUser({required UserModel userModel}) async {
    try {
      await _firestoreService.updateUserDocument(
        uid: userModel.uid,
        userData: userModel.toMap(),
      );
      
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getUserLikes({required String userUid}) async {
    try {
      return await _firestoreService.getUserLikes(userUid: userUid);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> addUserLike({
    required String userUid,
    required String postUid,
  }) async {
    try {
      await _firestoreService.addUserLike(
        userUid: userUid,
        postUid: postUid,
      );
      return unit;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> removeUserLike({
    required String userUid,
    required String postUid,
  }) async {
    try {
      await _firestoreService.removeUserLike(
        userUid: userUid,
        postUid: postUid,
      );
      return unit;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> deleteUser({required String uid}) async {
    try {
      await _storageService.deleteUserFolder(uid: uid);
      await _firestoreService.deleteUserDocument(uid: uid);
      return unit;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateUserProfileImage({
    required String uid,
    required XFile profileImage,
  }) async {
    try {
      return await _storageService.uploadProfileImage(
        uid: uid,
        imageFile: profileImage,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateUserCoverImage({
    required String uid,
    required XFile coverImage,
  }) async {
    try {
      return await _storageService.uploadCoverImage(
        uid: uid,
        imageFile: coverImage,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<UserModel> getUserStream({required String uid}) {
    try {
      return _firestoreService.getUserStream(uid: uid).map((doc) {
        if (!doc.exists || doc.data() == null) {
          throw Exception('User not found');
        }
        return UserModel.fromMap(doc.data()!);
      });
    } catch (e) {
      rethrow;
    }
  }
}