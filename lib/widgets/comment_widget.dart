import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pedalpulse/providers/user_likes_provider.dart';
import 'package:pedalpulse/services/firebase/comment_firestore_methods.dart';
import 'package:pedalpulse/utils/managers/color_manager.dart';
import 'package:pedalpulse/widgets/comment_dialog_widget.dart';
import 'package:pedalpulse/widgets/dragger_widget.dart';
import 'package:pedalpulse/widgets/reply_dialog_widget.dart';
import 'package:pedalpulse/widgets/reply_widget.dart';
import 'package:pedalpulse/widgets/user_avatar_widget.dart';
import 'package:provider/provider.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.post,
    required this.updatePost,
  });

  final CommentModel comment;
  final PostModel post;
  final Function updatePost;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late CommentModel _comment;
  bool _liked = false;
  bool _showAllReplies = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _comment = widget.comment;
    isLiked();
  }

  void getUpdatedComment(String commentUid) async {
    CommentModel comment = await CommentFirestoreMethods()
        .getCommentByUid(postUid: widget.post.uid, commentUid: commentUid);

    setState(() {
      _comment = comment;
    });
  }

  void handleLike() async {
    toggleLoading();

    UserModelDepr? user =
        Provider.of<UserProvider>(context, listen: false).user;
    if (_liked) {
      await CommentFirestoreMethods().unlikeComment(
        postUid: widget.post.uid,
        commentUid: _comment.uid,
      );

      Provider.of<UserLikesProvider>(context, listen: false)
          .removeLike(postUid: _comment.uid, userUid: user!.uid);
    } else {
      await CommentFirestoreMethods().likeComment(
        postUid: widget.post.uid,
        commentUid: _comment.uid,
      );

      Provider.of<UserLikesProvider>(context, listen: false)
          .addLike(postUid: _comment.uid, userUid: user!.uid);
    }
    getUpdatedComment(_comment.uid);

    setState(() {
      _liked = !_liked;
    });
    toggleLoading();
  }

  void isLiked() {
    List<String> likes =
        Provider.of<UserLikesProvider>(context, listen: false).userLikes;
    if (likes.contains(_comment.uid)) {
      setState(() {
        _liked = true;
      });
    }
  }

  void toggleShowAll() {
    setState(() {
      _showAllReplies = !_showAllReplies;
    });
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void deleteComment() async {
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
                    leading: Icon(Icons.delete),
                    subtitle: Text('Delete Comment?'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          CommentFirestoreMethods().deleteComment(
                            postUid: widget.post.uid,
                            commentUid: _comment.uid,
                          );
                          Navigator.pop(context);
                          widget.updatePost();
                          //show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Comment Deleted'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: ColorManager.appSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void editComment() {
    showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => CommentDialogWidget(
              post: widget.post,
              comment: _comment,
            ));
    Navigator.pop(context);
    widget.updatePost();
  }

  @override
  Widget build(BuildContext context) {
    UserModelDepr? user = Provider.of<UserProvider>(context).user;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorManager.primaryColorLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar, Username, and More Button
          Row(
            children: [
              UserAvatarWidget(
                userUid: _comment.userUid,
                isTappable: true,
                size: 15,
              ),
              const Spacer(),
              Text(
                Utils().timeAgo(_comment.createdAt),
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      if (_comment.userUid == user!.uid) {
                        return SizedBox(
                          height: 160,
                          child: Scaffold(
                            body: Column(
                              children: [
                                const DraggerWidget(),
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text("Edit"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return CommentDialogWidget(
                                          post: widget.post,
                                          comment: _comment,
                                        );
                                      },
                                    );
                                    getUpdatedComment(_comment.uid);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text("Delete"),
                                  onTap: deleteComment,
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
                                  title: const Text("Report Comment"),
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
                                                  leading: Icon(Icons.report),
                                                  title:
                                                      Text("Report Comment?"),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        await CommentFirestoreMethods()
                                                            .reportComment(
                                                          postUid:
                                                              widget.post.uid,
                                                          commentUid:
                                                              _comment.uid,
                                                          userUid: user.uid,
                                                        );

                                                        Navigator.pop(context);
                                                        // show snackbar
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                "Comment Reported"),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Report",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
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
                                      },
                                    );
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
              ),
            ],
          ),

          // Comment Section
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _comment.comment,
              style: const TextStyle(fontSize: 16),
            ),
          ),

          // Action Buttons
          Row(
            children: [
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _isLoading ? null : handleLike,
                child: Container(
                  height: 50,
                  width: 70,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(_liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          size: 18),
                      const SizedBox(width: 5),
                      Text(
                        _comment.likesCount.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (_comment.replies.length >= 100) {
                    return;
                  }
                  await showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => ReplyDialogWidget(
                      postUid: widget.post.uid,
                      comment: _comment,
                    ),
                  );
                  if (mounted) {
                    setState(() {
                      getUpdatedComment(_comment.uid);
                    });
                  }
                },
                child: SizedBox(
                  height: 30,
                  child: _comment.replies.length < 100
                      ? const Row(
                          children: [
                            Icon(Icons.comment_outlined, size: 18),
                            SizedBox(width: 5),
                            Text(
                              "Reply",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Reply",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: toggleShowAll,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      _comment.replies.isEmpty
                          ? const SizedBox()
                          : Icon(
                              _showAllReplies
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 18,
                              color: Colors.grey,
                            ),
                      const SizedBox(width: 5),
                      Text(
                        _comment.replies.length < 2
                            ? "${_comment.replies.length} Reply"
                            : "${_comment.replies.length} Replies",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 30),
              _comment.replies.isEmpty
                  ? const SizedBox()
                  : !_showAllReplies
                      ? const SizedBox()
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _comment.replies.length,
                            itemBuilder: (context, index) {
                              return ReplyWidget(
                                comment: _comment,
                                reply: _comment.replies[index],
                                refresh: widget.updatePost,
                              );
                            },
                          ),
                        )
            ],
          ),
        ],
      ),
    );
  }
}
