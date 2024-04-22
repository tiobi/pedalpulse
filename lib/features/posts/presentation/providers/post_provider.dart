import 'package:flutter/material.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_popular_posts_usecase.dart';
import '../../domain/usecases/get_recent_posts_usecase.dart';

class PostProvider extends ChangeNotifier {
  final List<PostEntity> _popularPosts = [];
  List<PostEntity> get popularPosts => _popularPosts;

  final List<PostEntity> _recentPosts = [];
  List<PostEntity> get recentPosts => _recentPosts;

  final GetRecentPostsUseCase getRecentPostsUseCase;
  final GetPopularPostsUseCase getPopularPostsUseCase;

  PostProvider({
    required this.getRecentPostsUseCase,
    required this.getPopularPostsUseCase,
  });

  Future<void> getFeaturedPosts() async {
    final popularPostsOrFailure = await getPopularPostsUseCase();
    final recentPostsOrFailure = await getRecentPostsUseCase();

    popularPostsOrFailure.fold(
      (l) {
        print('Error: $l');
      },
      (posts) {
        _popularPosts.clear();
        _popularPosts.addAll(posts);
        print(_popularPosts.length);
      },
    );

    recentPostsOrFailure.fold(
      (l) {
        print('Error: $l');
      },
      (posts) {
        _recentPosts.clear();
        _recentPosts.addAll(posts);
      },
    );

    notifyListeners();
  }
}
