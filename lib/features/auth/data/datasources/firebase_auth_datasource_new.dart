import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import '../../domain/entities/auth_entity.dart';
import '../../../user/data/models/user_model.dart';

abstract class FirebaseAuthDataSourceNew {
  Future<UserCredential> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  });

  Future<UserCredential> signInWithEmailAndPassword({
    required AuthEntity authEntity,
  });

  Future<Unit> sendEmailVerification();

  Future<Unit> initializeUserData({
    required String uid,
    required String email,
  });

  Future<Unit> sendPasswordResetEmail({
    required String email,
  });

  Future<Unit> signOut();

  Future<bool> isEmailVerified();

  Future<String> getCurrentUserUid();

  Stream<User?> get authStateChanges;
}

class FirebaseAuthDataSourceNewImpl implements FirebaseAuthDataSourceNew {
  final FirebaseAuthService _authService;

  FirebaseAuthDataSourceNewImpl({
    required FirebaseAuthService authService,
  }) : _authService = authService;

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required AuthEntity authEntity,
  }) async {
    try {
      final userCredential = await _authService.createUserWithEmailAndPassword(
        email: authEntity.email,
        password: authEntity.password,
      );

      if (_authService.getCurrentUser() == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }

      await _authService.sendEmailVerification();

      await initializeUserData(
        uid: _authService.getCurrentUserUid()!,
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
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: authEntity.email,
        password: authEntity.password,
      );

      if (userCredential.user != null) {
        if (!userCredential.user!.emailVerified) {
          await _authService.sendEmailVerification();
          throw FirebaseAuthException(
            code: 'email-not-verified',
            message: 'Email is not verified',
          );
        }

        if (!userCredential.user!.isAnonymous &&
            userCredential.user!.uid != _authService.getCurrentUserUid()) {
          throw FirebaseAuthException(
            code: 'user-not-authenticated',
            message: 'User is not properly authenticated',
          );
        }
      }

      return userCredential;
    } catch (e) {
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

      await _authService.createUserDocument(
        uid: uid,
        userData: newUser.toMap(),
      );
      
      return unit;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      return _authService.isEmailVerified();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
      return unit;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return unit;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Unit> signOut() async {
    try {
      await _authService.signOut();
      return unit;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getCurrentUserUid() async {
    try {
      final uid = _authService.getCurrentUserUid();
      if (uid == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }
      return uid;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;
}