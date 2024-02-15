// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pedalpulse/services/firebase/reply_firestore_methods.dart';
import 'package:pedalpulse/widgets/user_avatar_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:pedalpulse/models/comment_model.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/managers/message_manager.dart';
import 'custom_dynamic_height_textfield_widget.dart';
import '../features/auth/presentation/widgets/custom_text_button_widget.dart';
import 'loading_placeholder_widget.dart';

class ReplyDialogWidget extends StatefulWidget {
  final String postUid;
  final CommentModel comment;
  final CommentModel? reply;
  final bool isReview;

  const ReplyDialogWidget({
    Key? key,
    required this.postUid,
    required this.comment,
    this.isReview = false,
    this.reply,
  }) : super(key: key);

  @override
  State<ReplyDialogWidget> createState() => _ReplyDialogWidgetState();
}

class _ReplyDialogWidgetState extends State<ReplyDialogWidget> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.reply != null) {
      _textController.text = widget.reply!.comment;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // close
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 8),
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black45,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Replying to: ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),

              // comment
              Row(
                children: [
                  UserAvatarWidget(userUid: widget.comment.userUid),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.comment.comment,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              // reply
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 16, bottom: 8),
                child: Row(
                  children: [
                    UserAvatarWidget(userUid: user?.uid ?? ""),
                    const Spacer(),
                    _isLoading
                        ? const LoadingPlaceholderWidget(size: 30)
                        : CustomTextButtonWidget(
                            placeholder: "Post",
                            onTap: () async {
                              String message = NetworkMessageManager.error;
                              toggleLoading();

                              if (_textController.text.isEmpty) {
                                //show snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Reply cannot be empty"),
                                  ),
                                );

                                toggleLoading();
                                return;
                              }

                              // if reply is not null, then we are editing
                              // else we are adding a new reply
                              if (widget.reply == null) {
                                final CommentModel reply = CommentModel(
                                  uid: const Uuid().v4(),
                                  userUid: user?.uid ?? "",
                                  postUid: widget.postUid,
                                  comment: _textController.text,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );

                                message =
                                    await ReplyFirestoreMethods().addReply(
                                  reply: reply,
                                  commentUid: widget.comment.uid,
                                  isReview: widget.isReview,
                                );
                              } else {
                                final CommentModel reply =
                                    widget.reply!.copyWith(
                                  comment: _textController.text,
                                  updatedAt: DateTime.now(),
                                );

                                message =
                                    await ReplyFirestoreMethods().updateReply(
                                  commentUid: widget.comment.uid,
                                  reply: reply,
                                  isReview: widget.isReview,
                                );
                              }

                              toggleLoading();

                              if (message == NetworkMessageManager.success) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                  ],
                ),
              ),
              CustomDynamicHeightTextfieldWidget(
                textController: _textController,
                placeholder: "Reply",
                maxLength: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
