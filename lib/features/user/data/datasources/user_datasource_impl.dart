import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../domain/entities/user_entity.dart';
import 'user_datasource.dart';

class UserDataSourceImpl implements UserDataSource {
  FirebaseFirestore firestore;

  UserDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<UserEntity> getUser({
    required String uid,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDocument =
          await firestore.collection('users').doc(uid).get();

      return UserEntity(
        uid: userDocument.data()!['uid'],
        email: userDocument.data()!['email'],
        username: userDocument.data()!['name'],
        profileImage: userDocument.data()!['profileImage'],
        coverImage: userDocument.data()!['coverImage'],
        bio: userDocument.data()!['bio'],
        joinedAt: userDocument.data()!['joinedAt'].toDate(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> updateUser({
    required UserEntity userEntity,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getUserLikes({
    required String userUid,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addUserLike({
    required String userUid,
    required String postUid,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> removeUserLike({
    required String userUid,
    required String postUid,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser({
    required String uid,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserProfileImage({
    required String uid,
    XFile? profileImage,
    XFile? coverImage,
  }) async {
    throw UnimplementedError();
  }
}
