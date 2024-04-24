import '../models/post_model.dart';

abstract class PostFirestoreDataSource {
  Future<List<PostModel>> getPopularPosts({
    int limit = 10,
  });

  Future<List<PostModel>> getRecentPosts({
    int limit = 10,
  });

  Future<List<PostModel>> getPostsWithPedal({
    required String pedalUid,
    int limit = 10,
  });

  Future<PostModel> getPostByUid({
    required String postUid,
  });
}
