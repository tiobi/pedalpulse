import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedalpulse/services/firebase/firebase_storage_methods.dart';

import '../../models/user_model.dart';
import '../../utils/managers/message_manager.dart';

class UserFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadUserData({
    required String uid,
    required String email,
  }) async {
    try {
      UserModelDepr newUser = UserModelDepr(
        uid: uid,
        email: email,
        username: email.split('@')[0],
        profileImageUrl: '',
        backgroundImageUrl: '',
        bio: '',
        joinedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<UserModelDepr> getUserByUid({required String uid}) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return UserModelDepr.fromMap(doc.data()! as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateUserProfile({
    required String uid,
    required String username,
    required String bio,
    XFile? backgroundImageFile,
    XFile? profileImageFile,
  }) async {
    try {
      if (backgroundImageFile == null && profileImageFile == null) {
        await _firestore.collection('users').doc(uid).update({
          'username': username,
          'bio': bio,
        });
      } else if (backgroundImageFile == null) {
        final String profileImageUrl =
            await FirebaseStorageMethods().uploadProfileImageToStorage(
          uid: uid,
          image: profileImageFile!,
        );

        await _firestore.collection('users').doc(uid).update({
          'username': username,
          'bio': bio,
          'profileImageUrl': profileImageUrl,
        });
      } else if (profileImageFile == null) {
        final String backgroundImageUrl =
            await FirebaseStorageMethods().uploadBackgroundImageToStorage(
          uid: uid,
          image: backgroundImageFile,
        );

        await _firestore.collection('users').doc(uid).update({
          'username': username,
          'bio': bio,
          'backgroundImageUrl': backgroundImageUrl,
        });
      } else {
        final String profileImageUrl =
            await FirebaseStorageMethods().uploadProfileImageToStorage(
          uid: uid,
          image: profileImageFile,
        );

        final String backgroundImageUrl =
            await FirebaseStorageMethods().uploadBackgroundImageToStorage(
          uid: uid,
          image: backgroundImageFile,
        );

        await _firestore.collection('users').doc(uid).update({
          'username': username,
          'bio': bio,
          'profileImageUrl': profileImageUrl,
          'backgroundImageUrl': backgroundImageUrl,
        });
      }

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<bool> isUserExists({required String uid}) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> getUserLikes({required String userUid}) async {
    try {
      List<String> userLikes = [];

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userUid)
          .collection('likes')
          .get();

      for (var doc in querySnapshot.docs) {
        List<dynamic> likes = doc['likes'];
        userLikes.addAll(likes.cast<String>());
      }

      return userLikes;
    } catch (e) {
      return [];
    }
  }

  Future<String> addUserLike(
      {required String userUid, required String postUid}) async {
    try {
      // check the last document in the collection
      // if the document.length is more than 25,000, create a new document
      // store the uid in the last document
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userUid)
          .collection('likes')
          .get();

      int docLength = querySnapshot.docs.length;

      if (querySnapshot.docs[docLength - 1]['likes'].length >= 25000) {
        await _firestore
            .collection('users')
            .doc(userUid)
            .collection('likes')
            .doc('likes$docLength')
            .set({
          'likes': [postUid],
        });
      } else {
        await _firestore
            .collection('users')
            .doc(userUid)
            .collection('likes')
            .doc(querySnapshot.docs[docLength - 1].id)
            .update({
          'likes': FieldValue.arrayUnion([postUid]),
        });
      }

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> removeUserLike(
      {required String userUid, required String postUid}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userUid)
          .collection('likes')
          .get();

      for (var doc in querySnapshot.docs) {
        if (doc['likes'].contains(postUid)) {
          await _firestore
              .collection('users')
              .doc(userUid)
              .collection('likes')
              .doc(doc.id)
              .update({
            'likes': FieldValue.arrayRemove([postUid]),
          });
        }
      }

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> deleteUserData({required String uid}) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }
}
