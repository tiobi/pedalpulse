import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/entities/user_entity.dart';
import '../../../../models/user_model.dart';
import '../../domain/entities/auth_entity.dart';
import 'firebase_auth_datasource.dart';

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirebaseAuthDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<void> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: authEntity.email,
        password: authEntity.password,
      );
      await auth.currentUser!.sendEmailVerification();

      // TODO: initializeUserData is removed from this method. Implement it in the sign in.
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> initializeUserData({
    required String uid,
    required String email,
  }) async {
    try {
      UserModel newUser = UserModel(
        uid: uid,
        email: email,
        username: email.split('@')[0],
        profileImageUrl: '',
        backgroundImageUrl: '',
        bio: '',
        joinedAt: DateTime.now(),
      );

      await firestore.collection('users').doc(uid).set(newUser.toMap());
      return;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: authEntity.email,
        password: authEntity.password,
      );

      final user = auth.currentUser;
      if (user != null) {
        return UserEntity(
          uid: user.uid,
          email: user.email!,
          username: user.email!.split('@')[0],
          profileImageUrl: '',
          backgroundImageUrl: '',
          bio: '',
          joinedAt: DateTime.now(),
        );
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
