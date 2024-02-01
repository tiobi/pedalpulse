import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedalpulse/models/comment_model.dart';
import 'package:pedalpulse/utils/managers/message_manager.dart';

class CommentFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addComment({required CommentModel comment}) async {
    try {
      final post = _firestore.collection('posts').doc(comment.postUid);
      await post.collection('comments').doc(comment.uid).set(comment.toMap());

      await post.update({
        'commentsCount': FieldValue.increment(1),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> updateComment({required CommentModel comment}) async {
    try {
      final post = _firestore.collection('posts').doc(comment.postUid);
      await post
          .collection('comments')
          .doc(comment.uid)
          .update(comment.toMap());

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<List<CommentModel>> getFeaturedCommentsByPostUid({
    required String postUid,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('posts')
          .doc(postUid)
          .collection('comments')
          .orderBy('likesCount', descending: true)
          .limit(3)
          .get();

      final List<CommentModel> featuredComments = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              CommentModel.fromMap(e.data()))
          .toList();

      return featuredComments;
    } catch (e) {
      return [];
    }
  }

  Future<List<CommentModel>> getUserCommentsByPostUid({
    required String postUid,
    required String userUid,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('posts')
          .doc(postUid)
          .collection('comments')
          .where('userUid', isEqualTo: userUid)
          .orderBy('createdAt', descending: true)
          .get();

      final List<CommentModel> userComments = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              CommentModel.fromMap(e.data()))
          .toList();

      return userComments;
    } catch (e) {
      return [];
    }
  }

  Future<CommentModel> getCommentByUid(
      {required String postUid, required String commentUid}) async {
    return await _firestore
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .doc(commentUid)
        .get()
        .then((value) =>
            CommentModel.fromMap(value.data() as Map<String, dynamic>));
  }

  Future<String> likeComment({
    required String postUid,
    required String commentUid,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> commentRef = _firestore
          .collection('posts')
          .doc(postUid)
          .collection('comments')
          .doc(commentUid);

      await commentRef.update({
        'likesCount': FieldValue.increment(1),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> unlikeComment({
    required String postUid,
    required String commentUid,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> commentRef = _firestore
          .collection('posts')
          .doc(postUid)
          .collection('comments')
          .doc(commentUid);

      await commentRef.update({
        'likesCount': FieldValue.increment(-1),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> deleteComment({
    required String postUid,
    required String commentUid,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> commentRef = _firestore
          .collection('posts')
          .doc(postUid)
          .collection('comments')
          .doc(commentUid);

      _firestore.collection('posts').doc(postUid).update({
        'commentsCount': FieldValue.increment(-1),
      });

      await commentRef.delete();

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> reportComment({
    required String postUid,
    required String commentUid,
    required String userUid,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> commentRef = _firestore
          .collection('posts')
          .doc(postUid)
          .collection('comments')
          .doc(commentUid);

      await commentRef.update({
        'reportedBy': FieldValue.arrayUnion([userUid]),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }
}
