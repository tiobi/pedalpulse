import 'package:flutter/material.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../services/firebase/post_firestore_methods.dart';
import '../utils/managers/color_manager.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/admob_banner_ad_widget.dart';
import '../widgets/comment_dialog_widget.dart';
import '../widgets/comment_widget.dart';
import '../widgets/custom_text_button_widget.dart';
import '../widgets/loading_placeholder_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel post;
  const CommentsScreen({Key? key, required this.post}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final List<CommentModel> _comments = [];
  final int _batch = 10;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late PostModel _post;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch initial comments when the screen loads
    _post = widget.post;
    fetchData();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  bool isMoreCommentsAvailable() {
    return _comments.length < _post.commentsCount;
  }

  Future<void> fetchData() async {
    toggleLoading();
    Query query = _firestore
        .collection('posts')
        .doc(_post.uid)
        .collection('comments')
        .orderBy('createdAt', descending: true);

    if (_comments.isNotEmpty) {
      // Load more comments using the last likesCount as the startAfter value
      query = query.startAfter([_comments.last.createdAt]);
    }

    // Fetch the next 10 comments
    final comments = await query.limit(_batch).get().then((value) => value.docs
        .map((e) => CommentModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());

    setState(() {
      _comments.addAll(comments);
    });
    toggleLoading();
  }

  void getUpdatedPost() async {
    PostModel post =
        await PostFirestoreMethods().getPostByUid(postUid: _post.uid);

    setState(() {
      _post = post;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStringManager.comments),
        forceMaterialTransparency: true,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 5),
                  height: 40,
                  width: width - 20,
                  decoration: const BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(
                          color: ColorManager.primaryColorLight, width: 2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        Text(AppStringManager.addComment),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () async {
                await showCupertinoModalBottomSheet(
                  expand: true,
                  elevation: 100,
                  context: context,
                  builder: (context) => CommentDialogWidget(
                    post: _post,
                  ),
                );
                // update comments count
                setState(() {
                  _comments.clear();
                  fetchData();
                });
              },
            ),

            // Comments
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                CommentModel comment = _comments[index];
                return CommentWidget(
                  post: _post,
                  comment: comment,
                  updatePost: getUpdatedPost,
                );
              },
            ),
            _isLoading
                ? const LoadingPlaceholderWidget()
                : isMoreCommentsAvailable()
                    ? Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 16.0),
                            child: CustomTextButtonWidget(
                              onTap: fetchData,
                              placeholder: AppStringManager.seeMoreComments,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),

            const AdMobBannerAdWidget(adType: AdType.mediumRectangle),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
