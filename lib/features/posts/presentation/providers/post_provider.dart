import 'package:flutter/material.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/get_feed_posts_usecase.dart';
import '../../domain/usecases/get_popular_posts_usecase.dart';
import '../../domain/usecases/get_post_by_uid_usecase.dart';
import '../../domain/usecases/get_posts_with_pedal_usecase.dart';
import '../../domain/usecases/get_recent_posts_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';
import '../../domain/usecases/unlike_post_usecase.dart';
import '../state/post_state.dart';

class PostProvider extends ChangeNotifier {
  final GetRecentPostsUseCase getRecentPostsUseCase;
  final GetPopularPostsUseCase getPopularPostsUseCase;
  final GetFeedPostsUseCase getFeedPostsUseCase;
  final GetPostsWithPedalUseCase getPostsWithPedalUseCase;
  final GetPostByUidUseCase getPostByUidUseCase;
  final LikePostUseCase likePostUseCase;
  final UnlikePostUseCase unlikePostUseCase;
  final DeletePostUseCase deletePostUseCase;

  PostProvider({
    required this.getRecentPostsUseCase,
    required this.getPopularPostsUseCase,
    required this.getFeedPostsUseCase,
    required this.getPostsWithPedalUseCase,
    required this.getPostByUidUseCase,
    required this.likePostUseCase,
    required this.unlikePostUseCase,
    required this.deletePostUseCase,
  });

  PostState _popularPostsState = PostInitial();
  PostState get popularPostsState => _popularPostsState;

  PostState _recentPostsState = PostInitial();
  PostState get recentPostsState => _recentPostsState;

  PostState _feedPostsState = PostInitial();
  PostState get feedPostsState => _feedPostsState;

  PostState _postsWithPedalState = PostInitial();
  PostState get postsWithPedalState => _postsWithPedalState;

  SinglePostState _singlePostState = SinglePostInitial();
  SinglePostState get singlePostState => _singlePostState;

  PostInteractionState _interactionState = PostInteractionInitial();
  PostInteractionState get interactionState => _interactionState;

  List<PostEntity> get popularPosts {
    if (_popularPostsState is PostSuccess) {
      return (_popularPostsState as PostSuccess).posts;
    }
    return [];
  }

  List<PostEntity> get recentPosts {
    if (_recentPostsState is PostSuccess) {
      return (_recentPostsState as PostSuccess).posts;
    }
    return [];
  }

  List<PostEntity> get feedPosts {
    if (_feedPostsState is PostSuccess) {
      return (_feedPostsState as PostSuccess).posts;
    }
    return [];
  }

  List<PostEntity> get postsWithPedal {
    if (_postsWithPedalState is PostSuccess) {
      return (_postsWithPedalState as PostSuccess).posts;
    }
    return [];
  }

  PostEntity? get currentPost {
    if (_singlePostState is SinglePostSuccess) {
      return (_singlePostState as SinglePostSuccess).post;
    }
    return null;
  }

  bool get isLoadingPopular => _popularPostsState is PostLoading;
  bool get isLoadingRecent => _recentPostsState is PostLoading;
  bool get isLoadingFeed => _feedPostsState is PostLoading;
  bool get isLoadingPostsWithPedal => _postsWithPedalState is PostLoading;
  bool get isLoadingSinglePost => _singlePostState is SinglePostLoading;
  bool get isProcessingInteraction => _interactionState is PostInteractionLoading;

  Future<void> initProvider() async {
    await Future.wait([
      getFeedPosts(),
      getPopularPosts(),
      getRecentPosts(),
    ]);
  }

  Future<void> getFeedPosts({bool refresh = false}) async {
    if (!refresh && _feedPostsState is PostLoading) return;
    
    _feedPostsState = PostLoading();
    notifyListeners();

    final result = await getFeedPostsUseCase();

    result.fold(
      (failure) {
        _feedPostsState = PostError(failure.message);
      },
      (posts) {
        _feedPostsState = PostSuccess(posts);
      },
    );

    notifyListeners();
  }

  Future<void> getPopularPosts({bool refresh = false}) async {
    if (!refresh && _popularPostsState is PostLoading) return;
    
    _popularPostsState = PostLoading();
    notifyListeners();

    final result = await getPopularPostsUseCase();

    result.fold(
      (failure) {
        _popularPostsState = PostError(failure.message);
      },
      (posts) {
        _popularPostsState = PostSuccess(posts);
      },
    );

    notifyListeners();
  }

  Future<void> getRecentPosts({bool refresh = false}) async {
    if (!refresh && _recentPostsState is PostLoading) return;
    
    _recentPostsState = PostLoading();
    notifyListeners();

    final result = await getRecentPostsUseCase();

    result.fold(
      (failure) {
        _recentPostsState = PostError(failure.message);
      },
      (posts) {
        _recentPostsState = PostSuccess(posts);
      },
    );

    notifyListeners();
  }

  Future<void> getPostsWithPedal({
    required String pedalUid,
    bool refresh = false,
  }) async {
    if (!refresh && _postsWithPedalState is PostLoading) return;
    
    _postsWithPedalState = PostLoading();
    notifyListeners();

    final result = await getPostsWithPedalUseCase(pedalUid: pedalUid);

    result.fold(
      (failure) {
        _postsWithPedalState = PostError(failure.message);
      },
      (posts) {
        _postsWithPedalState = PostSuccess(posts);
      },
    );

    notifyListeners();
  }

  Future<void> getPostByUid({required String postUid}) async {
    if (_singlePostState is SinglePostLoading) return;
    
    _singlePostState = SinglePostLoading();
    notifyListeners();

    final result = await getPostByUidUseCase(postUid: postUid);

    result.fold(
      (failure) {
        _singlePostState = SinglePostError(failure.message);
      },
      (post) {
        _singlePostState = SinglePostSuccess(post);
      },
    );

    notifyListeners();
  }

  Future<void> likePost({
    required String postUid,
    required String userUid,
  }) async {
    if (_interactionState is PostInteractionLoading) return;

    _interactionState = PostInteractionLoading();
    notifyListeners();

    final result = await likePostUseCase(
      postUid: postUid,
      userUid: userUid,
    );

    result.fold(
      (failure) {
        _interactionState = PostInteractionError(failure.message);
      },
      (_) {
        _interactionState = PostInteractionSuccess();
        _updatePostInLists(postUid, (post) => _addLikeToPost(post, userUid));
      },
    );

    notifyListeners();
  }

  Future<void> unlikePost({
    required String postUid,
    required String userUid,
  }) async {
    if (_interactionState is PostInteractionLoading) return;

    _interactionState = PostInteractionLoading();
    notifyListeners();

    final result = await unlikePostUseCase(
      postUid: postUid,
      userUid: userUid,
    );

    result.fold(
      (failure) {
        _interactionState = PostInteractionError(failure.message);
      },
      (_) {
        _interactionState = PostInteractionSuccess();
        _updatePostInLists(postUid, (post) => _removeLikeFromPost(post, userUid));
      },
    );

    notifyListeners();
  }

  Future<void> deletePost({
    required String postUid,
    required String currentUserUid,
  }) async {
    if (_interactionState is PostInteractionLoading) return;

    _interactionState = PostInteractionLoading();
    notifyListeners();

    final result = await deletePostUseCase(
      postUid: postUid,
      currentUserUid: currentUserUid,
    );

    result.fold(
      (failure) {
        _interactionState = PostInteractionError(failure.message);
      },
      (_) {
        _interactionState = PostInteractionSuccess();
        _removePostFromLists(postUid);
      },
    );

    notifyListeners();
  }

  void _updatePostInLists(String postUid, PostEntity Function(PostEntity) updater) {
    _updatePostsInState(_feedPostsState, (posts) => _updatePostInList(posts, postUid, updater));
    _updatePostsInState(_popularPostsState, (posts) => _updatePostInList(posts, postUid, updater));
    _updatePostsInState(_recentPostsState, (posts) => _updatePostInList(posts, postUid, updater));
    _updatePostsInState(_postsWithPedalState, (posts) => _updatePostInList(posts, postUid, updater));

    if (_singlePostState is SinglePostSuccess) {
      final currentPost = (_singlePostState as SinglePostSuccess).post;
      if (currentPost.uid == postUid) {
        _singlePostState = SinglePostSuccess(updater(currentPost));
      }
    }
  }

  void _updatePostsInState(PostState state, List<PostEntity> Function(List<PostEntity>) updater) {
    if (state is PostSuccess) {
      final updatedPosts = updater(state.posts);
      if (state == _feedPostsState) _feedPostsState = PostSuccess(updatedPosts);
      if (state == _popularPostsState) _popularPostsState = PostSuccess(updatedPosts);
      if (state == _recentPostsState) _recentPostsState = PostSuccess(updatedPosts);
      if (state == _postsWithPedalState) _postsWithPedalState = PostSuccess(updatedPosts);
    }
  }

  List<PostEntity> _updatePostInList(
    List<PostEntity> posts,
    String postUid,
    PostEntity Function(PostEntity) updater,
  ) {
    return posts.map((post) => post.uid == postUid ? updater(post) : post).toList();
  }

  void _removePostFromLists(String postUid) {
    if (_feedPostsState is PostSuccess) {
      final posts = (_feedPostsState as PostSuccess).posts;
      _feedPostsState = PostSuccess(posts.where((post) => post.uid != postUid).toList());
    }
    if (_popularPostsState is PostSuccess) {
      final posts = (_popularPostsState as PostSuccess).posts;
      _popularPostsState = PostSuccess(posts.where((post) => post.uid != postUid).toList());
    }
    if (_recentPostsState is PostSuccess) {
      final posts = (_recentPostsState as PostSuccess).posts;
      _recentPostsState = PostSuccess(posts.where((post) => post.uid != postUid).toList());
    }
    if (_postsWithPedalState is PostSuccess) {
      final posts = (_postsWithPedalState as PostSuccess).posts;
      _postsWithPedalState = PostSuccess(posts.where((post) => post.uid != postUid).toList());
    }
  }

  PostEntity _addLikeToPost(PostEntity post, String userUid) {
    final newLikes = List<String>.from(post.likes);
    if (!newLikes.contains(userUid)) {
      newLikes.add(userUid);
    }
    return post.copyWith(
      likes: newLikes,
      likesCount: newLikes.length,
    );
  }

  PostEntity _removeLikeFromPost(PostEntity post, String userUid) {
    final newLikes = List<String>.from(post.likes);
    newLikes.remove(userUid);
    return post.copyWith(
      likes: newLikes,
      likesCount: newLikes.length,
    );
  }

  void clearInteractionState() {
    _interactionState = PostInteractionInitial();
    notifyListeners();
  }

  void refreshAll() {
    getFeedPosts(refresh: true);
    getPopularPosts(refresh: true);
    getRecentPosts(refresh: true);
  }
}
