import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pedalpulse/providers/user_likes_provider.dart';
import 'package:pedalpulse/widgets/dragger_widget.dart';
import 'package:pedalpulse/widgets/rating_widget.dart';
import 'package:pedalpulse/widgets/reply_dialog_widget.dart';
import 'package:pedalpulse/widgets/reply_widget.dart';
import 'package:pedalpulse/widgets/review_dialog_widget.dart';
import 'package:pedalpulse/widgets/user_avatar_widget.dart';
import 'package:provider/provider.dart';

import '../models/comment_model.dart';
import '../models/pedal_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../services/firebase/review_firestore_methods.dart';
import '../utils/managers/color_manager.dart';
import '../utils/utils.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    super.key,
    required this.comment,
    required this.pedal,
    this.showReply = false,
    required this.updateReview,
  });

  final CommentModel comment;
  final PedalModel pedal;
  final bool showReply;
  final Function updateReview;

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  late CommentModel _review;
  bool liked = false;
  bool _showReplies = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _review = widget.comment;
    isLiked();
  }

  void getUpdatedReview(String commentUid) async {
    CommentModel comment = await ReviewFirestoreMethods()
        .getReviewByUid(pedalUid: widget.pedal.uid, commentUid: commentUid);

    setState(() {
      _review = comment;
    });
  }

  void handleLike() async {
    toggleLoading();
    UserModel? user = Provider.of<UserProvider>(context, listen: false).user;
    if (liked) {
      await ReviewFirestoreMethods().unlikeReview(
        pedalUid: widget.pedal.uid,
        commentUid: _review.uid,
      );

      Provider.of<UserLikesProvider>(context, listen: false)
          .removeLike(postUid: _review.uid, userUid: user!.uid);
    } else {
      await ReviewFirestoreMethods().likeReview(
        pedalUid: widget.pedal.uid,
        commentUid: _review.uid,
      );

      Provider.of<UserLikesProvider>(context, listen: false)
          .addLike(postUid: _review.uid, userUid: user!.uid);
    }
    getUpdatedReview(_review.uid);
    toggleLoading();
    setState(() {
      liked = !liked;
    });
  }

  void isLiked() {
    List<String> likes =
        Provider.of<UserLikesProvider>(context, listen: false).userLikes;
    if (likes.contains(_review.uid)) {
      setState(() {
        liked = true;
      });
    }
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void toggleShowReplies() {
    setState(() {
      _showReplies = !_showReplies;
    });
  }

  void editReview() {
    Navigator.pop(context);
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return ReviewDialogWidget(pedal: widget.pedal, review: _review);
      },
    );
    widget.updateReview;
  }

  void deleteReview() async {
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
                        onPressed: () async {
                          await ReviewFirestoreMethods().deleteReview(
                            review: _review,
                          );
                          Navigator.pop(context);
                          widget.updateReview;
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

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).user;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorManager.primaryColorLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar and More Button
          Row(
            children: [
              UserAvatarWidget(
                userUid: _review.userUid,
                isTappable: true,
                size: 15,
              ),
              const Spacer(),
              Text(
                Utils().timeAgo(_review.createdAt),
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      if (_review.userUid == user!.uid) {
                        return SizedBox(
                          height: 160,
                          child: Scaffold(
                            body: Column(
                              children: [
                                const DraggerWidget(),
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text("Edit"),
                                  onTap: editReview,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text("Delete"),
                                  onTap: deleteReview,
                                )
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
                                                        await ReviewFirestoreMethods()
                                                            .reportReview(
                                                          review: _review,
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

          // Rating
          RatingWidget(
            rating: _review.rating!,
            uid: _review.uid,
          ),

          // Comment Section
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _review.comment,
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
                      Icon(liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          size: 18),
                      const SizedBox(width: 5),
                      Text(
                        _review.likesCount.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: const SizedBox(
                  height: 30,
                  child: Row(
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
                  ),
                ),
                onTap: () async {
                  await showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => ReplyDialogWidget(
                      postUid: widget.pedal.uid,
                      comment: _review,
                      isReview: true,
                    ),
                  );
                  if (mounted) {
                    setState(() {
                      getUpdatedReview(_review.uid);
                    });
                  }
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: toggleShowReplies,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      _review.replies.isEmpty
                          ? const SizedBox()
                          : Icon(
                              _showReplies
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 18,
                              color: Colors.grey,
                            ),
                      const SizedBox(width: 5),
                      Text(
                        _review.replies.length < 2
                            ? "${_review.replies.length} Reply"
                            : "${_review.replies.length} Replies",
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
              _review.replies.isEmpty
                  ? const SizedBox()
                  : _showReplies
                      ? Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _review.replies.length,
                            itemBuilder: (context, index) {
                              return ReplyWidget(
                                reply: _review.replies[index],
                                comment: _review,
                                isReview: true,
                                refresh: widget.updateReview,
                              );
                            },
                          ),
                        )
                      : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
