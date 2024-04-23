import 'package:flutter/material.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_feed_posts_usecase.dart';
import '../../domain/usecases/get_popular_posts_usecase.dart';
import '../../domain/usecases/get_recent_posts_usecase.dart';

class PostProvider extends ChangeNotifier {
  final List<PostEntity> _popularPosts = [];
  List<PostEntity> get popularPosts => _popularPosts;

  final List<PostEntity> _recentPosts = [];
  List<PostEntity> get recentPosts => _recentPosts;

  final List<PostEntity> _feedPosts = [];
  List<PostEntity> get feedPosts => _feedPosts;

  final GetRecentPostsUseCase getRecentPostsUseCase;
  final GetPopularPostsUseCase getPopularPostsUseCase;
  final GetFeedPostsUseCase getFeedPostsUseCase;

  PostProvider({
    required this.getRecentPostsUseCase,
    required this.getPopularPostsUseCase,
    required this.getFeedPostsUseCase,
  });

  Future<void> initProvider() async {
    await getFeedPosts();
    await getPopularPosts();
    await getRecentPosts();
  }

  Future<void> getFeedPosts() async {
    final feedPostsOrFailure = await getFeedPostsUseCase();

    feedPostsOrFailure.fold(
      (l) {},
      (posts) {
        _feedPosts.clear();
        _feedPosts.addAll(posts);
      },
    );

    notifyListeners();
  }

  Future<void> getPopularPosts() async {
    final popularPostsOrFailure = await getPopularPostsUseCase();

    popularPostsOrFailure.fold(
      (l) {},
      (posts) {
        _popularPosts.clear();
        _popularPosts.addAll(posts);
      },
    );

    notifyListeners();
  }

  Future<void> getRecentPosts() async {
    final recentPostsOrFailure = await getRecentPostsUseCase();

    recentPostsOrFailure.fold(
      (l) {},
      (posts) {
        _recentPosts.clear();
        _recentPosts.addAll(posts);
      },
    );

    notifyListeners();
  }
}
