import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pedalpulse/features/posts/data/datasources/post_firestore_datasource.dart';
import 'package:pedalpulse/features/posts/data/models/post_model.dart';

class PostFirestoreDataSourceImpl implements PostFirestoreDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  PostFirestoreDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<List<PostModel>> getPopularPosts({int limit = 3}) async {
    try {
      final posts = await firestore
          .collection('posts')
          .orderBy('likesCount', descending: true)
          .limit(limit)
          .get();

      return posts.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostModel>> getRecentPosts({int limit = 3}) async {
    try {
      final posts = await firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return posts.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostModel>> getPostsWithPedal(
      {required String pedalUid, int limit = 10}) async {
    try {
      final posts = await firestore
          .collection('posts')
          .where('pedalUids', arrayContains: pedalUid)
          .limit(limit)
          .get();

      return posts.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PostModel> getPostByUid({required String postUid}) async {
    try {
      final post = await firestore.collection('posts').doc(postUid).get();

      return PostModel.fromMap(post.data()!);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PostModel>> getFeedPosts({int limit = 10}) async {
    try {
      final posts = await firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .where('reports', isLessThan: 5)
          .limit(limit)
          .get();

      return posts.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> createPost({required PostModel post}) async {
    try {
      final docRef = await firestore.collection('posts').add(post.toMap());
      
      await firestore.collection('posts').doc(docRef.id).update({
        'uid': docRef.id,
      });
      
      return docRef.id;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updatePost({required PostModel post}) async {
    try {
      await firestore.collection('posts').doc(post.uid).update({
        ...post.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deletePost({required String postUid}) async {
    try {
      await firestore.collection('posts').doc(postUid).delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> likePost({
    required String postUid,
    required String userUid,
  }) async {
    try {
      final batch = firestore.batch();
      final postRef = firestore.collection('posts').doc(postUid);
      
      batch.update(postRef, {
        'likes': FieldValue.arrayUnion([userUid]),
        'likesCount': FieldValue.increment(1),
      });
      
      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> unlikePost({
    required String postUid,
    required String userUid,
  }) async {
    try {
      final batch = firestore.batch();
      final postRef = firestore.collection('posts').doc(postUid);
      
      batch.update(postRef, {
        'likes': FieldValue.arrayRemove([userUid]),
        'likesCount': FieldValue.increment(-1),
      });
      
      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<String>> uploadImages({required List<String> imagePaths}) async {
    try {
      final List<String> downloadUrls = [];
      
      for (int i = 0; i < imagePaths.length; i++) {
        final String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final Reference ref = storage.ref().child(fileName);
        
        final UploadTask uploadTask = ref.putFile(File(imagePaths[i]));
        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        
        downloadUrls.add(downloadUrl);
      }
      
      return downloadUrls;
    } catch (e) {
      throw Exception(e);
    }
  }
}
