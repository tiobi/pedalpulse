import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedalpulse/features/posts/data/datasources/post_firestore_datasource.dart';
import 'package:pedalpulse/features/posts/data/models/post_model.dart';

class PostFirestoreDataSourceImpl implements PostFirestoreDataSource {
  final FirebaseFirestore firestore;

  PostFirestoreDataSourceImpl({required this.firestore});

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
}
