import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/loading_placeholder_widget.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/post_provider.dart';
import '../state/post_state.dart';
import 'enhanced_post_card_widget.dart';

enum PostListType {
  feed,
  popular,
  recent,
  withPedal,
}

class EnhancedPostListWidget extends StatefulWidget {
  final PostListType listType;
  final String? pedalUid;
  final String? currentUserUid;
  final EdgeInsets? padding;
  final bool enablePullToRefresh;
  final bool enableInfiniteScroll;

  const EnhancedPostListWidget({
    super.key,
    required this.listType,
    this.pedalUid,
    this.currentUserUid,
    this.padding,
    this.enablePullToRefresh = true,
    this.enableInfiniteScroll = false,
  });

  @override
  State<EnhancedPostListWidget> createState() => _EnhancedPostListWidgetState();
}

class _EnhancedPostListWidgetState extends State<EnhancedPostListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.enableInfiniteScroll) {
      _scrollController.addListener(_onScroll);
    }
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    
    switch (widget.listType) {
      case PostListType.feed:
        postProvider.getFeedPosts();
        break;
      case PostListType.popular:
        postProvider.getPopularPosts();
        break;
      case PostListType.recent:
        postProvider.getRecentPosts();
        break;
      case PostListType.withPedal:
        if (widget.pedalUid != null) {
          postProvider.getPostsWithPedal(pedalUid: widget.pedalUid!);
        }
        break;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    // TODO: Implement pagination
    // This would require updating the use cases to support pagination
  }

  Future<void> _onRefresh() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    
    switch (widget.listType) {
      case PostListType.feed:
        await postProvider.getFeedPosts(refresh: true);
        break;
      case PostListType.popular:
        await postProvider.getPopularPosts(refresh: true);
        break;
      case PostListType.recent:
        await postProvider.getRecentPosts(refresh: true);
        break;
      case PostListType.withPedal:
        if (widget.pedalUid != null) {
          await postProvider.getPostsWithPedal(
            pedalUid: widget.pedalUid!,
            refresh: true,
          );
        }
        break;
    }
  }

  PostState _getCurrentState(PostProvider postProvider) {
    switch (widget.listType) {
      case PostListType.feed:
        return postProvider.feedPostsState;
      case PostListType.popular:
        return postProvider.popularPostsState;
      case PostListType.recent:
        return postProvider.recentPostsState;
      case PostListType.withPedal:
        return postProvider.postsWithPedalState;
    }
  }

  List<PostEntity> _getCurrentPosts(PostProvider postProvider) {
    switch (widget.listType) {
      case PostListType.feed:
        return postProvider.feedPosts;
      case PostListType.popular:
        return postProvider.popularPosts;
      case PostListType.recent:
        return postProvider.recentPosts;
      case PostListType.withPedal:
        return postProvider.postsWithPedal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, _) {
        final state = _getCurrentState(postProvider);
        final posts = _getCurrentPosts(postProvider);

        if (state is PostLoading && posts.isEmpty) {
          return _buildLoadingState();
        }

        if (state is PostError && posts.isEmpty) {
          return _buildErrorState(state.message);
        }

        if (posts.isEmpty) {
          return _buildEmptyState();
        }

        return _buildPostList(posts, state is PostLoading);
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingPlaceholderWidget(size: 50),
          SizedBox(height: 16),
          Text(
            'Loading posts...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadInitialData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String emptyMessage = 'No posts available';
    IconData emptyIcon = Icons.post_add;

    switch (widget.listType) {
      case PostListType.feed:
        emptyMessage = 'Your feed is empty\nStart following users to see their posts';
        emptyIcon = Icons.rss_feed;
        break;
      case PostListType.popular:
        emptyMessage = 'No popular posts yet\nBe the first to create an amazing post!';
        emptyIcon = Icons.trending_up;
        break;
      case PostListType.recent:
        emptyMessage = 'No recent posts\nCreate the first post of the day!';
        emptyIcon = Icons.schedule;
        break;
      case PostListType.withPedal:
        emptyMessage = 'No posts with this pedal yet\nBe the first to showcase it!';
        emptyIcon = Icons.music_note;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              emptyIcon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (widget.listType != PostListType.feed)
              ElevatedButton(
                onPressed: () {
                  // Navigate to create post
                },
                child: const Text('Create Post'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(List<PostEntity> posts, bool isLoadingMore) {
    Widget listView = ListView.builder(
      controller: _scrollController,
      padding: widget.padding ?? EdgeInsets.zero,
      itemCount: posts.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= posts.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: LoadingPlaceholderWidget(size: 30),
            ),
          );
        }

        final post = posts[index];
        return EnhancedPostCardWidget(
          post: post,
          currentUserUid: widget.currentUserUid,
        );
      },
    );

    if (widget.enablePullToRefresh) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: listView,
      );
    }

    return listView;
  }
}