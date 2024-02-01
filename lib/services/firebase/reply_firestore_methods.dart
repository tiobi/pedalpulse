import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/comment_model.dart';
import '../../utils/managers/message_manager.dart';

class ReplyFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addReply({
    required String commentUid,
    required CommentModel reply,
    bool isReview = false,
  }) async {
    try {
      if (isReview) {
        _firestore
            .collection('pedals')
            .doc(reply.postUid)
            .collection('reviews')
            .doc(commentUid)
            .update({
          'replies': FieldValue.arrayUnion([reply.toMap()]),
        });
      } else {
        _firestore
            .collection('posts')
            .doc(reply.postUid)
            .collection('comments')
            .doc(commentUid)
            .update({
          'replies': FieldValue.arrayUnion([reply.toMap()]),
        });
      }

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> updateReply({
    required String commentUid,
    required CommentModel reply,
    bool isReview = false,
  }) async {
    try {
      if (isReview) {
        var reviewSnap = await _firestore
            .collection('pedals')
            .doc(reply.postUid)
            .collection('reviews')
            .doc(commentUid)
            .get();

        CommentModel review =
            CommentModel.fromMap(reviewSnap.data() as Map<String, dynamic>);
        List<CommentModel> replies = review.replies;

        if (replies.isNotEmpty) {
          for (int i = 0; i < replies.length; i++) {
            if (replies[i].uid == reply.uid) {
              replies[i] = reply;
              break;
            }
          }
        }

        await _firestore
            .collection('pedals')
            .doc(reply.postUid)
            .collection('reviews')
            .doc(commentUid)
            .update({
          'replies': replies.map((e) => e.toMap()).toList(),
        });
      } else {
        // is comment
        var commentSnap = await _firestore
            .collection('posts')
            .doc(reply.postUid)
            .collection('comments')
            .doc(commentUid)
            .get();

        CommentModel comment =
            CommentModel.fromMap(commentSnap.data() as Map<String, dynamic>);
        List<CommentModel> replies = comment.replies;

        if (replies.isNotEmpty) {
          for (int i = 0; i < replies.length; i++) {
            if (replies[i].uid == reply.uid) {
              replies[i] = reply;
              break;
            }
          }
        }

        await _firestore
            .collection('posts')
            .doc(reply.postUid)
            .collection('comments')
            .doc(commentUid)
            .update({
          'replies': replies.map((e) => e.toMap()).toList(),
        });
      }
      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> deleteReply({
    required String commentUid,
    required CommentModel reply,
    bool isReview = false,
  }) async {
    try {
      if (isReview) {
        var reviewSnap = await _firestore
            .collection('pedals')
            .doc(reply.postUid)
            .collection('reviews')
            .doc(commentUid)
            .get();

        CommentModel review =
            CommentModel.fromMap(reviewSnap.data() as Map<String, dynamic>);
        List<CommentModel> replies = review.replies;

        if (replies.isNotEmpty) {
          for (int i = 0; i < replies.length; i++) {
            if (replies[i].uid == reply.uid) {
              replies.removeAt(i);
              break;
            }
          }
        }

        await _firestore
            .collection('pedals')
            .doc(reply.postUid)
            .collection('reviews')
            .doc(commentUid)
            .update({
          'replies': replies.map((e) => e.toMap()).toList(),
        });
      } else {
        // is comment
        var commentSnap = await _firestore
            .collection('posts')
            .doc(reply.postUid)
            .collection('comments')
            .doc(commentUid)
            .get();

        CommentModel comment =
            CommentModel.fromMap(commentSnap.data() as Map<String, dynamic>);
        List<CommentModel> replies = comment.replies;

        if (replies.isNotEmpty) {
          for (int i = 0; i < replies.length; i++) {
            if (replies[i].uid == reply.uid) {
              replies.removeAt(i);
              break;
            }
          }
        }

        await _firestore
            .collection('posts')
            .doc(reply.postUid)
            .collection('comments')
            .doc(commentUid)
            .update({
          'replies': replies.map((e) => e.toMap()).toList(),
        });
      }
      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> reportReply({
    required String commentUid,
    required CommentModel reply,
    required String userUid,
    bool isReview = false,
  }) async {
    try {
      if (isReview) {
        var reviewSnap = await _firestore
            .collection('pedals')
            .doc(reply.postUid)
            .collection('reviews')
            .doc(commentUid)
            .get();

        CommentModel comment =
            CommentModel.fromMap(reviewSnap.data() as Map<String, dynamic>);

        for (var element in comment.replies) {
          if (element.uid == reply.uid) {
            if (!element.reportedBy.contains(userUid)) {
              element.reportedBy.add(userUid);
            }
          }
        }

        await _firestore
            .collection('pedals')
            .doc(reply.postUid)
            .collection('reviews')
            .doc(commentUid)
            .update({
          'replies': comment.replies.map((e) => e.toMap()).toList(),
        });
      } else {
        // is comment
        var commentSnap = await _firestore
            .collection('posts')
            .doc(reply.postUid)
            .collection('comments')
            .doc(commentUid)
            .get();

        CommentModel comment =
            CommentModel.fromMap(commentSnap.data() as Map<String, dynamic>);

        for (var element in comment.replies) {
          if (element.uid == reply.uid) {
            if (!element.reportedBy.contains(userUid)) {
              element.reportedBy.add(userUid);
            }
          }
        }

        await _firestore
            .collection('posts')
            .doc(reply.postUid)
            .collection('comments')
            .doc(commentUid)
            .update({
          'replies': comment.replies.map((e) => e.toMap()).toList(),
        });
      }
      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }
}
