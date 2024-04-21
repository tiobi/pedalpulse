import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../models/user_model.dart';
import 'user_datasource.dart';

class UserDataSourceImpl implements UserDataSource {
  FirebaseFirestore firestore;

  UserDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<UserModel> getUser({
    required String uid,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDocument =
          await firestore.collection('users').doc(uid).get();

      return UserModel.fromMap(userDocument.data()!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUser({
    required UserModel userModel,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toMap());

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getUserLikes({
    required String userUid,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Unit> addUserLike({
    required String userUid,
    required String postUid,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Unit> removeUserLike({
    required String userUid,
    required String postUid,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Unit> deleteUser({
    required String uid,
  }) async {
    try {
      await firestore.collection('users').doc(uid).delete();
      return unit;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> updateUserProfileImage({
    required String uid,
    XFile? profileImage,
    XFile? coverImage,
  }) async {
    throw UnimplementedError();
  }
}
