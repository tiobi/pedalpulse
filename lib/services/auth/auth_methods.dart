import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedalpulse/providers/user_provider_depr.dart';

import '../../models/user_model.dart';
import '../../utils/managers/message_manager.dart';
import '../firebase/user_firestore_methods.dart';

class AuthMethods {
  final _auth = FirebaseAuth.instance;

  // Sign in with email and password
  // Send verification email
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      if (!isPasswordConfirmed(
        password: password,
        confirmPassword: confirmPassword,
      )) {
        return NetworkMessageManager.passwordNotMatched;
      }

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.currentUser!.sendEmailVerification();
      await UserFirestoreMethods().uploadUserData(
        uid: _auth.currentUser!.uid,
        email: email,
      );

      return NetworkMessageManager.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return NetworkMessageManager.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return NetworkMessageManager.emailAlreadyInUse;
      }
      return NetworkMessageManager.error;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  // Check if email is verified
  // Sign in with email and password
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return NetworkMessageManager.emptyFields;
      }

      // sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await UserProviderDepr().setUser();

      // check if email is verified
      if (!await isEmailVerified(email: email)) {
        return NetworkMessageManager.emailNotVerified;
      }

      return NetworkMessageManager.success;
    } catch (e) {
      if (e.toString() == 'user-not-found') {
        return NetworkMessageManager.userNotFound;
      } else if (e.toString() == 'wrong-password') {
        return NetworkMessageManager.wrongPassword;
      }
      return NetworkMessageManager.error;
    }
  }

  Future<bool> isEmailVerified({required String email}) async {
    return _auth.currentUser!.emailVerified;
  }

  // Check if password and confirm password are the same
  bool isPasswordConfirmed({
    required String password,
    required String confirmPassword,
  }) {
    return password == confirmPassword;
  }

  // Send password reset email
  Future<String> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return NetworkMessageManager.success;
    } catch (e) {
      if (e.toString() == 'user-not-found') {
        return NetworkMessageManager.userNotFound;
      }
      return NetworkMessageManager.error;
    }
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<UserModelDepr> getUserDetails() async {
    User? user = _auth.currentUser;
    if (user == null) {
      // User user = FirebaseAuth.instance.currentUser!;
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    return UserModelDepr.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<String> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      // Delete user data from firestore
      await UserFirestoreMethods().deleteUserData(uid: user!.uid);
      await user.delete();

      // Delete user from authentication

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }
}
