import 'package:flutter/material.dart';
import 'package:pedalpulse/services/firebase/comment_firestore_methods.dart';
import 'package:pedalpulse/widgets/dragger_widget.dart';
import 'package:pedalpulse/widgets/loading_placeholder_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/managers/message_manager.dart';
import 'custom_dynamic_height_textfield_widget.dart';
import 'custom_text_button_widget.dart';

class CommentDialogWidget extends StatefulWidget {
  final PostModel post;
  final CommentModel? comment;

  const CommentDialogWidget({
    super.key,
    this.comment,
    required this.post,
  });

  @override
  State<CommentDialogWidget> createState() => _CommentDialogWidgetState();
}

class _CommentDialogWidgetState extends State<CommentDialogWidget> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.comment != null) {
      _textController.text = widget.comment!.comment;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DraggerWidget(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Adding a comment to: ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.post.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 24, top: 16, bottom: 8),
              child: user == null
                  ? const CircularProgressIndicator()
                  : Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.profileImageUrl),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            user.username,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                                        content:
                                            Text("Comment cannot be empty"),
                                      ),
                                    );
                                    return;
                                  }

                                  // if comment is not null, then we are editing
                                  // else we are adding a new comment
                                  if (widget.comment == null) {
                                    final CommentModel comment = CommentModel(
                                      uid: const Uuid().v4(),
                                      postUid: widget.post.uid,
                                      userUid: user.uid,
                                      comment: _textController.text,
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                    );

                                    message = await CommentFirestoreMethods()
                                        .addComment(comment: comment);
                                  } else {
                                    final CommentModel comment =
                                        widget.comment!.copyWith(
                                      comment: _textController.text,
                                      updatedAt: DateTime.now(),
                                    );
                                    message = await CommentFirestoreMethods()
                                        .updateComment(comment: comment);
                                  }

                                  toggleLoading();

                                  if (message ==
                                      NetworkMessageManager.success) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                      ],
                    ),
            ),
            CustomDynamicHeightTextfieldWidget(
              textController: _textController,
              placeholder: "Leave a comment",
              maxLength: 500,
            ),
          ],
        ),
      ),
    );
  }
}
