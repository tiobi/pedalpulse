import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pedalpulse/models/search_option_model.dart';
import 'package:pedalpulse/models/user_post_model.dart';

import '../../models/pedal_model.dart';
import '../../models/post_model.dart';
import '../../utils/managers/message_manager.dart';
import 'firebase_storage_methods.dart';

class PostFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String postUid,
    required userUid,
    required username,
    required userProfileImageUrl,
    required title,
    required description,
    required List<XFile>? imageList,
    required List<PedalModel> pedalList,
  }) async {
    List<String> pedalUids = pedalList.map((pedal) => pedal.uid).toList();

    List<String> imageUrls =
        await FirebaseStorageMethods().uploadPostImagesToStorage(
      userUid: userUid,
      postUid: postUid,
      images: imageList ?? [],
    );

    PostModel post = PostModel(
      uid: postUid,
      userUid: userUid,
      username: username,
      userProfileImageUrl: userProfileImageUrl,
      imageUrls: imageUrls,
      title: title,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      likes: [],
      reports: [],
      likesCount: 0,
      commentsCount: 0,
      pedalList: pedalList,
      pedalUids: pedalUids,
      views: 0,
    );

    try {
      await _firestore.collection('posts').doc(postUid).set(post.toMap());
      UserPostModel userPost = UserPostModel(
        userUid: userUid,
        postUid: postUid,
        postTitle: title,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userUid)
          .collection('userPosts')
          .doc(postUid)
          .set(userPost.toMap());

      return NetworkMessageManager.success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updatePost(
      {required List<XFile>? imageList, required PostModel post}) async {
    try {
      // Delete old images by referencing their urls in the post
      // Upload new images and get their urls
      // Update the post with the new image urls and other data

      List<String> oldImageUrls = post.imageUrls;
      FirebaseStorageMethods().deletePostImagesFromStorage(
          userUid: post.userUid, postUid: post.uid, imageUrls: oldImageUrls);

      List<String> newImageUrls = await FirebaseStorageMethods()
          .uploadPostImagesToStorage(
              userUid: post.userUid,
              postUid: post.uid,
              images: imageList ?? []);

      post.copyWith(imageUrls: newImageUrls);

      await _firestore.collection('posts').doc(post.uid).update(post.toMap());

      return NetworkMessageManager.success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<PostModel>> getRecentPosts({int? limit}) async {
    try {
      if (limit == null || limit == 0) {
        return await _firestore
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .get()
            .then((value) =>
                value.docs.map((e) => PostModel.fromMap(e.data())).toList());
      }

      return await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get()
          .then((value) =>
              value.docs.map((e) => PostModel.fromMap(e.data())).toList());
    } catch (e) {
      return [];
    }
  }

  Future<List<PostModel>> getPostsByPedalUid(
      {required String pedalUid, int? limit}) async {
    try {
      // if the limit is not specified, get all posts
      if (limit == null || limit == 0) {
        return await _firestore
            .collection('posts')
            .where('pedalUids', arrayContains: pedalUid)
            .get()
            .then((value) =>
                value.docs.map((e) => PostModel.fromMap(e.data())).toList());
      }

      return await _firestore
          .collection('posts')
          .where('pedalUids', arrayContains: pedalUid)
          .limit(limit)
          .get()
          .then((value) =>
              value.docs.map((e) => PostModel.fromMap(e.data())).toList());
    } catch (e) {
      return [];
    }
  }

  Future<PostModel> getPostByUid({required String postUid}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('posts').doc(postUid).get();

      return PostModel.fromMap(documentSnapshot.data()!);
    } catch (e) {
      return PostModel(
        uid: '',
        userUid: '',
        username: '',
        userProfileImageUrl: '',
        imageUrls: [],
        title: '',
        description: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        likes: [],
        reports: [],
        likesCount: 0,
        commentsCount: 0,
        pedalList: [],
        pedalUids: [],
        views: 0,
      );
    }
  }

  Future<List<PostModel>> getPostsByUserUid(
      {required String userUid, int? limit}) async {
    try {
      if (limit != null) {
        return await _firestore
            .collection('posts')
            .where('userUid', isEqualTo: userUid)
            .limit(limit)
            .get()
            .then((value) =>
                value.docs.map((e) => PostModel.fromMap(e.data())).toList());
      }

      return await _firestore
          .collection('posts')
          .where('userUid', isEqualTo: userUid)
          .get()
          .then((value) =>
              value.docs.map((e) => PostModel.fromMap(e.data())).toList());
    } catch (e) {
      return [];
    }
  }

  Future<List<PostModel>> getPostsWithOptions(
      {required SearchOptionModel searchOption}) async {
    try {
      // Look at the SearchOption enum in models/search_option_model.dart
      // Implement the logic for each search option
      // Use Switch Case and call the appropriate method for each case

      switch (searchOption.searchOption) {
        case SearchOption.RECENT:
          return await getRecentPosts();
        case SearchOption.USER:
          return await getPostsByUserUid(userUid: searchOption.argument!);
        case SearchOption.PEDAL:
          return await getPostsByPedalUid(pedalUid: searchOption.argument!);
        default:
          return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> likePost({required String postUid}) async {
    try {
      final DocumentReference<Map<String, dynamic>> postRef =
          _firestore.collection('posts').doc(postUid);

      await postRef.update({
        'likesCount': FieldValue.increment(1),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> unlikePost({required String postUid}) async {
    try {
      final DocumentReference<Map<String, dynamic>> postRef =
          _firestore.collection('posts').doc(postUid);

      await postRef.update({
        'likesCount': FieldValue.increment(-1),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> reportPost(
      {required String postUid, required String userUid}) async {
    try {
      final DocumentReference<Map<String, dynamic>> postRef =
          _firestore.collection('posts').doc(postUid);

      await postRef.update({
        'reports': FieldValue.arrayUnion([userUid]),
      });

      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<String> deletePost({required PostModel post}) async {
    try {
      FirebaseStorageMethods().deletePostImagesFromStorage(
          userUid: post.userUid, postUid: post.uid, imageUrls: post.imageUrls);
      await _firestore.collection('posts').doc(post.uid).delete();
      return NetworkMessageManager.success;
    } catch (e) {
      return NetworkMessageManager.error;
    }
  }

  Future<List<PostModel>> getPopularPosts({int? limit}) async {
    try {
      if (limit == null || limit == 0) {
        return await _firestore
            .collection('posts')
            .orderBy('likesCount', descending: true)
            .get()
            .then((value) =>
                value.docs.map((e) => PostModel.fromMap(e.data())).toList());
      }

      return await _firestore
          .collection('posts')
          .orderBy('likesCount', descending: true)
          .limit(limit)
          .get()
          .then((value) =>
              value.docs.map((e) => PostModel.fromMap(e.data())).toList());
    } catch (e) {
      return [];
    }
  }

  Future<List<PostModel>> getPopularPostsOfTheWeek({int? limit}) async {
    // get the posts of the week
    // sort them by likes

    try {
      if (limit == null || limit == 0) {
        return await _firestore
            .collection('posts')
            .where('createdAt',
                isGreaterThan: DateTime.now().subtract(const Duration(days: 7)))
            .orderBy('likesCount', descending: true)
            .get()
            .then((value) =>
                value.docs.map((e) => PostModel.fromMap(e.data())).toList());
      }

      return await _firestore
          .collection('posts')
          .where('createdAt',
              isGreaterThan: DateTime.now().subtract(const Duration(days: 7)))
          .orderBy('likesCount', descending: true)
          .limit(limit)
          .get()
          .then((value) =>
              value.docs.map((e) => PostModel.fromMap(e.data())).toList());
    } catch (e) {
      return [];
    }
  }
}
