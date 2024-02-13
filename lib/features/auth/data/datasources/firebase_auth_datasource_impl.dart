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
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: authEntity.email,
        password: authEntity.password,
      );

      // User null check
      if (auth.currentUser == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }

      await auth.currentUser!.sendEmailVerification();

      await initializeUserData(
        uid: auth.currentUser!.uid,
        email: authEntity.email,
      );

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: authEntity.email,
        password: authEntity.password,
      );

      // check if user is verified
      if (isEmailVerified(email: authEntity.email) == false) {
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email is not verified',
        );
      }

      return userCredential;
    } on FirebaseAuthException {
      rethrow;
    }
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
  Future<bool> isEmailVerified({required String email}) async {
    try {
      User? user = auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }
      return user.emailVerified;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<Unit> sendEmailVerification({
    required String email,
  }) async {
    try {
      auth.currentUser!.sendEmailVerification();
      return unit;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<Unit> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return unit;
    } on FirebaseAuthException {
      rethrow;
    }
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
