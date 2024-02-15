import 'package:flutter/material.dart';

import '../layouts/hidable_bottom_navigation_bar.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../providers/user_likes_provider.dart';
import '../providers/user_provider.dart';
import '../responsive/mobile_layout.dart';
import '../screens/upload_post_screen.dart';
import '../services/firebase/comment_firestore_methods.dart';
import '../services/firebase/post_firestore_methods.dart';
import '../utils/managers/asset_manager.dart';
import '../utils/managers/color_manager.dart';
import '../utils/managers/route_manager.dart';
import '../utils/managers/string_manager.dart';
import '../utils/utils.dart';
import '../widgets/admob_banner_ad_widget.dart';
import '../widgets/comment_dialog_widget.dart';
import '../widgets/comment_widget.dart';
import '../features/auth/presentation/widgets/custom_text_button_widget.dart';
import '../widgets/dragger_widget.dart';
import '../widgets/image_pageview_indicator_widget.dart';
import '../widgets/safe_area_padding_widget.dart';
import '../widgets/sidescroll_pedal_listview_widget.dart';
import '../widgets/user_avatar_widget.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostModel post;
  const PostDetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  late PostModel _post;
  bool _isLiked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    isLiked();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void getUpdatedPost() async {
    PostModel post =
        await PostFirestoreMethods().getPostByUid(postUid: widget.post.uid);
    setState(() {
      _post = post;
    });
  }

  Future<List<CommentModel>> getFeaturedComments() async {
    final List<CommentModel> comments = await CommentFirestoreMethods()
        .getFeaturedCommentsByPostUid(postUid: widget.post.uid);
    return comments;
  }

  void toggleLiked() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void handleLike() async {
    toggleLoading();

    UserModel? user = Provider.of<UserProvider>(context, listen: false).user;
    if (_isLiked) {
      await PostFirestoreMethods().unlikePost(postUid: _post.uid);

      Provider.of<UserLikesProvider>(context, listen: false)
          .removeLike(postUid: _post.uid, userUid: user!.uid);
    }

    if (!_isLiked) {
      await PostFirestoreMethods().likePost(postUid: _post.uid);

      Provider.of<UserLikesProvider>(context, listen: false)
          .addLike(postUid: _post.uid, userUid: user!.uid);
    }
    toggleLoading();
    toggleLiked();
    getUpdatedPost();
  }

  void isLiked() {
    List<String> userLikes =
        Provider.of<UserLikesProvider>(context, listen: false).userLikes;
    if (userLikes.contains(_post.uid)) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    UserModel user = Provider.of<UserProvider>(context).user!;

    return Scaffold(
      bottomNavigationBar: HidableBottomNavigationBar(
        scrollController: _scrollController,
        items: bottomNavigationBarItems,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getUpdatedPost;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SafeAreaPaddingWidget(),
              _post.imageUrls.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      color: ColorManager.primaryColorLight,
                      width: width,
                      child: Center(
                        child: Image.asset(
                          ImageAssetManager.appLogoWhite,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : ImagePageviewIndicatorWidget(
                      imageUrls: _post.imageUrls,
                    ),

              // Post info and description
              Container(
                width: width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _post.title,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        UserAvatarWidget(
                          userUid: _post.userUid,
                          size: 20,
                          isTappable: true,
                        ),
                        const Spacer(),
                        Text(
                          Utils().timeAgo(_post.createdAt),
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) {
                                if (_post.userUid == user.uid) {
                                  return SizedBox(
                                    height: 160,
                                    child: Scaffold(
                                      body: Column(
                                        children: [
                                          const DraggerWidget(),
                                          ListTile(
                                            leading: const Icon(Icons.edit),
                                            title: const Text(
                                                AppStringManager.editPost),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showCupertinoModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return UploadPostScreen(
                                                        post: _post);
                                                  });
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.delete),
                                            title: const Text(
                                                AppStringManager.deletePost),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showCupertinoModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return SizedBox(
                                                    height: 120,
                                                    child: Scaffold(
                                                      body: Column(
                                                        children: [
                                                          const ListTile(
                                                            leading: Icon(
                                                                Icons.delete),
                                                            title: Text(
                                                                AppStringManager
                                                                    .deletePostWarning),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  PostFirestoreMethods()
                                                                      .deletePost(
                                                                          post:
                                                                              _post);
                                                                  Navigator.pop(
                                                                      context);
                                                                  //show snackbar
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content: Text(
                                                                          AppStringManager
                                                                              .postDeleted),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    ),
                                                                  );
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    AppStringManager
                                                                        .delete,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey)),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  AppStringManager
                                                                      .cancel,
                                                                  style:
                                                                      TextStyle(
                                                                    color: ColorManager
                                                                        .appSecondaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 100,
                                    child: Scaffold(
                                      body: Column(
                                        children: [
                                          const DraggerWidget(),
                                          ListTile(
                                            leading: const Icon(Icons.report),
                                            title: const Text(
                                                AppStringManager.reportPost),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showCupertinoModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      height: 120,
                                                      child: Scaffold(
                                                        body: Column(
                                                          children: [
                                                            const ListTile(
                                                              leading: Icon(
                                                                  Icons.report),
                                                              title: Text(
                                                                  AppStringManager
                                                                      .reportPostWarning),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    await PostFirestoreMethods().reportPost(
                                                                        postUid:
                                                                            _post
                                                                                .uid,
                                                                        userUid:
                                                                            user.uid);
                                                                    Navigator.pop(
                                                                        context);
                                                                    // show snackbar
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text(AppStringManager.postReported),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    AppStringManager
                                                                        .report,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    AppStringManager
                                                                        .cancel,
                                                                    style:
                                                                        TextStyle(
                                                                      color: ColorManager
                                                                          .appSecondaryColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _post.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GestureDetector(
                  onTap: _isLoading ? null : handleLike,
                  child: Container(
                    height: 50,
                    width: 90,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                            _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                            size: 20),
                        const SizedBox(width: 5),
                        Text(
                          _post.likesCount.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const AdMobBannerAdWidget(adType: AdType.largeBanner),

              _post.pedalList.isEmpty
                  ? const SizedBox()
                  : SidescrollPedalListviewWidget(
                      title: AppStringManager.pedalsUsed,
                      pedalList: _post.pedalList,
                    ),

              // comment section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      _post.commentsCount < 2
                          ? "${_post.commentsCount} ${AppStringManager.comment}"
                          : "${_post.commentsCount} ${AppStringManager.comments}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: getUpdatedPost,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
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
                  getUpdatedPost();
                },
              ),

              FutureBuilder<List<CommentModel>>(
                future: getFeaturedComments(),
                builder: (context, AsyncSnapshot<List<CommentModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final comments = snapshot.data!;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return CommentWidget(
                          post: _post,
                          comment: comments[index],
                          updatePost: getUpdatedPost,
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(AppStringManager.noComments));
                  }
                },
              ),

              _post.commentsCount > 3
                  ? Row(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            right: 16,
                          ),
                          child: CustomTextButtonWidget(
                            placeholder:
                                "${AppStringManager.seeAll} ${_post.commentsCount} ${AppStringManager.comments}",
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.comments, arguments: _post);
                            },
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),

              const SizedBox(height: 50),
              const AdMobBannerAdWidget(adType: AdType.mediumRectangle),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
