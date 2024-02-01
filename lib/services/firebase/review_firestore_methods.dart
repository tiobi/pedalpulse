import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/comment_model.dart';
import '../../utils/managers/message_manager.dart';

class ReviewFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addReview({required CommentModel comment}) async {
    try {
      final pedal = _firestore.collection('pedals').doc(comment.postUid);
      await pedal.collection('reviews').doc(comment.uid).set(comment.toMap());
      await pedal.update({
        'commentsCount': FieldValue.increment(1),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> updateReview({required CommentModel review}) async {
    try {
      final post = _firestore.collection('pedals').doc(review.postUid);
      await post.collection('reviews').doc(review.uid).update(review.toMap());

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> deleteReview({required CommentModel review}) async {
    try {
      final pedalRef = _firestore.collection('pedals').doc(review.postUid);

      final reviewRef = pedalRef.collection('reviews').doc(review.uid);

      pedalRef.update({'commentsCount': FieldValue.increment(-1)});
      await reviewRef.delete();

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> reportReview({
    required CommentModel review,
    required String userUid,
  }) async {
    try {
      final pedalRef = _firestore.collection('pedals').doc(review.postUid);

      final reviewRef = pedalRef.collection('reviews').doc(review.uid);

      await reviewRef.update({
        'reportedBy': FieldValue.arrayUnion([userUid]),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<List<CommentModel>> getFeaturedReviewsByPedalUid({
    required String pedalUid,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('pedals')
          .doc(pedalUid)
          .collection('reviews')
          .orderBy('likesCount', descending: true)
          .limit(3)
          .get();

      final List<CommentModel> comments = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              CommentModel.fromMap(e.data()))
          .toList();

      return comments;
    } catch (e) {
      return [];
    }
  }

  Future<CommentModel> getReviewByUid(
      {required String pedalUid, required String commentUid}) async {
    return await _firestore
        .collection('pedals')
        .doc(pedalUid)
        .collection('reviews')
        .doc(commentUid)
        .get()
        .then((value) =>
            CommentModel.fromMap(value.data() as Map<String, dynamic>));
  }

  Future<String> addReplyToReview({
    required String pedalUid,
    required String commentUid,
    required CommentModel reply,
  }) async {
    try {
      _firestore
          .collection('pedals')
          .doc(pedalUid)
          .collection('reviews')
          .doc(commentUid)
          .update({
        'replies': FieldValue.arrayUnion([reply.toMap()])
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> likeReview({
    required String pedalUid,
    required String commentUid,
  }) async {
    try {
      _firestore
          .collection('pedals')
          .doc(pedalUid)
          .collection('reviews')
          .doc(commentUid)
          .update({
        'likesCount': FieldValue.increment(1),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> unlikeReview({
    required String pedalUid,
    required String commentUid,
  }) async {
    try {
      _firestore
          .collection('pedals')
          .doc(pedalUid)
          .collection('reviews')
          .doc(commentUid)
          .update({
        'likesCount': FieldValue.increment(-1),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }
}
