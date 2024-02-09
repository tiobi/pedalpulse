import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<UserCredential> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try {
      throw UnimplementedError();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required AuthEntity authEntity}) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Unit> initializeUserData({
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
      return unit;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<bool> isEmailVerified({required String email}) {
    // TODO: implement isEmailVerified
    throw UnimplementedError();
  }

  @override
  Future<Unit> sendEmailVerification({required String email}) {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

  @override
  Future<Unit> sendPasswordResetEmail({required String email}) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<Unit> signOut() async {
    try {
      await auth.signOut();
      return unit;
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
