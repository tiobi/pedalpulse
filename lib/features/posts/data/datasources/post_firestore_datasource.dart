import '../models/post_model.dart';

abstract class PostFirestoreDataSource {
  Future<List<PostModel>> getPopularPosts({
    int limit = 10,
  });

  Future<List<PostModel>> getRecentPosts({
    int limit = 10,
  });

  Future<List<PostModel>> getFeedPosts({
    int limit = 10,
  });

  Future<List<PostModel>> getPostsWithPedal({
    required String pedalUid,
    int limit = 10,
  });

  Future<PostModel> getPostByUid({
    required String postUid,
  });

  Future<String> createPost({
    required PostModel post,
  });

  Future<void> updatePost({
    required PostModel post,
  });

  Future<void> deletePost({
    required String postUid,
  });

  Future<void> likePost({
    required String postUid,
    required String userUid,
  });

  Future<void> unlikePost({
    required String postUid,
    required String userUid,
  });

  Future<List<String>> uploadImages({
    required List<String> imagePaths,
  });
}
