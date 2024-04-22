import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pedalpulse/utils/managers/message_manager.dart';
import 'package:pedalpulse/widgets/reply_dialog_widget.dart';
import 'package:pedalpulse/widgets/user_avatar_widget.dart';
import 'package:provider/provider.dart';

import '../models/comment_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider_depr.dart';
import '../services/firebase/reply_firestore_methods.dart';
import '../utils/managers/color_manager.dart';
import '../utils/utils.dart';
import 'dragger_widget.dart';

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({
    super.key,
    required this.reply,
    required this.comment,
    this.isReview = false,
    required this.refresh,
  });

  final CommentModel reply;
  final CommentModel comment;
  final bool isReview;
  final Function refresh;

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  void editReply() {
    Navigator.pop(context);

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return ReplyDialogWidget(
          postUid: widget.reply.postUid,
          comment: widget.comment,
          reply: widget.reply,
          isReview: widget.isReview,
        );
      },
    );
  }

  void deleteReply() {
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
                        String message = NetworkMessageManager.error;
                        message = await ReplyFirestoreMethods().deleteReply(
                          commentUid: widget.comment.uid,
                          reply: widget.reply,
                          isReview: widget.isReview,
                        );
                        Navigator.pop(context);
                        widget.refresh();
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModelDepr? user = Provider.of<UserProviderDepr>(context).user;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatarWidget(
                userUid: widget.reply.userUid,
                isTappable: true,
              ),
              const Spacer(),
              Text(
                Utils().timeAgo(widget.reply.createdAt),
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      if (widget.reply.userUid == user?.uid) {
                        return SizedBox(
                          height: 160,
                          child: Scaffold(
                            body: Column(
                              children: [
                                const DraggerWidget(),
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text("Edit"),
                                  onTap: editReply,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text("Delete"),
                                  onTap: deleteReply,
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
                                  title: const Text("Report"),
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
                                                        ReplyFirestoreMethods()
                                                            .reportReply(
                                                          commentUid: widget
                                                              .comment.uid,
                                                          reply: widget.reply,
                                                          userUid: user!.uid,
                                                          isReview:
                                                              widget.isReview,
                                                        );

                                                        Navigator.pop(context);
                                                        // show snackbar
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              "Comment Reported",
                                                            ),
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
                                            )));
                                      },
                                    );
                                  },
                                )
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
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.reply.comment,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
