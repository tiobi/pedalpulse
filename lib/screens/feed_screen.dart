import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/post_model.dart';
import '../models/search_option_model.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/loading_placeholder_widget.dart';
import '../widgets/post_card_widget.dart';
import '../features/auth/presentation/widgets/custom_text_button_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final List<PostModel> _posts = [];
  final PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 0);
  final int _batch = 10;
  bool _isLoading = false;
  SearchOptionModel _searchOption = SearchOptionModel(
    searchOption: SearchOption.RECENT,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchData();
    });
  }

  void toggleLoading() {
    if (mounted) {
      setState(() {
        _isLoading = !_isLoading;
      });
    }
  }

  bool isMorePostsAvailable() {
    return _posts.length % _batch == 0;
  }

  Future<void> fetchData() async {
    final SearchOptionModel searchOption =
        ModalRoute.of(context)?.settings.arguments as SearchOptionModel? ??
            SearchOptionModel(
              searchOption: SearchOption.RECENT,
            );
    setState(() {
      _searchOption = searchOption;
    });
    toggleLoading();

    Query query = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true);

    if (_searchOption.searchOption == SearchOption.POPULAR) {
      Query query0 = FirebaseFirestore.instance
          .collection('posts')
          .orderBy('likesCount', descending: true);

      query = query0;
    } else if (_searchOption.searchOption == SearchOption.USER) {
      Query query0 = FirebaseFirestore.instance
          .collection('posts')
          .where('userUid', isEqualTo: _searchOption.argument)
          .orderBy('createdAt', descending: true);

      query = query0;
    } else if (_searchOption.searchOption == SearchOption.PEDAL) {
      Query query0 = FirebaseFirestore.instance
          .collection('posts')
          .where('pedalUids', arrayContains: _searchOption.argument)
          .orderBy('createdAt', descending: true);

      query = query0;
    }

    // get the first 10 posts
    final posts = await query.limit(_batch).get().then((value) => value.docs
        .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());

    if (mounted) {
      setState(() {
        _posts.addAll(posts);
        _pagingController.appendLastPage(posts);
      });
    }

    if (_posts.isNotEmpty) {
      // Load more posts using the last createdAt as the startAfter value
      query = query.startAfter([_posts.last.createdAt]);
    }

    toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(AppStringManager.posts),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return null;
                // return PostCardWidget(
                //   post: post,
                // );
              },
            ),
            _isLoading
                ? const LoadingPlaceholderWidget()
                : isMorePostsAvailable()
                    ? Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 16.0),
                            child: CustomTextButtonWidget(
                              onTap: fetchData,
                              placeholder: AppStringManager.getMorePosts,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
