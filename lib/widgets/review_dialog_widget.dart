import 'package:flutter/material.dart';
import 'package:pedalpulse/services/firebase/review_firestore_methods.dart';
import 'package:pedalpulse/widgets/custom_slider_widget.dart';
import 'package:pedalpulse/widgets/loading_placeholder_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/comment_model.dart';
import '../models/pedal_model.dart';
import '../models/rating_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/managers/message_manager.dart';
import 'custom_dynamic_height_textfield_widget.dart';
import 'custom_text_button_widget.dart';

class ReviewDialogWidget extends StatefulWidget {
  final PedalModel pedal;
  final CommentModel? review;

  const ReviewDialogWidget({
    super.key,
    required this.pedal,
    this.review,
  });

  @override
  State<ReviewDialogWidget> createState() => _ReviewDialogWidgetState();
}

class _ReviewDialogWidgetState extends State<ReviewDialogWidget> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  double accessibilityValue = 40;
  double soundValue = 40;
  double buildQualityValue = 40;
  double versatilityValue = 40;

  @override
  void initState() {
    super.initState();

    if (widget.review != null) {
      CommentModel review = widget.review!;
      _textController.text = review.comment;

      if (review.rating != null) {
        RatingModel rating = review.rating!;
        soundValue = rating.sound.toDouble();
        accessibilityValue = rating.accessibility.toDouble();
        buildQualityValue = rating.buildQuality.toDouble();
        versatilityValue = rating.versatility.toDouble();
      }
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

  double getOverall() {
    return (accessibilityValue +
            soundValue +
            buildQualityValue +
            versatilityValue) /
        4;
  }

  void onSoundChanged(double value) {
    setState(() {
      soundValue = value;
    });
  }

  void onBuildQualityChanged(double value) {
    setState(() {
      buildQualityValue = value;
    });
  }

  void onVersatilityChanged(double value) {
    setState(() {
      versatilityValue = value;
    });
  }

  void onAccessibilityChanged(double value) {
    setState(() {
      accessibilityValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Adding a review to: ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.pedal.name,
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
                                    String message =
                                        NetworkMessageManager.error;
                                    toggleLoading();
                                    if (_textController.text.isEmpty) {
                                      //show snackbar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Comment cannot be empty"),
                                        ),
                                      );
                                      toggleLoading();
                                      return;
                                    }

                                    final RatingModel rating = RatingModel(
                                        overall: getOverall(),
                                        accessibility: accessibilityValue,
                                        sound: soundValue,
                                        buildQuality: buildQualityValue,
                                        versatility: versatilityValue);

                                    if (widget.review == null) {
                                      final CommentModel comment = CommentModel(
                                        uid: const Uuid().v4(),
                                        postUid: widget.pedal.uid,
                                        userUid: user.uid,
                                        comment: _textController.text,
                                        createdAt: DateTime.now(),
                                        updatedAt: DateTime.now(),
                                        likesCount: 0,
                                        replies: [],
                                        rating: rating,
                                        reportedBy: [],
                                      );

                                      message = await ReviewFirestoreMethods()
                                          .addReview(comment: comment);
                                    } else {
                                      final CommentModel review =
                                          widget.review!.copyWith(
                                        rating: rating,
                                        updatedAt: DateTime.now(),
                                        comment: _textController.text,
                                      );

                                      message = await ReviewFirestoreMethods()
                                          .updateReview(review: review);
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.2,
                  ),
                  children: [
                    CustomSliderWidget(
                      value: soundValue,
                      text: "Sound",
                      onChanged: onSoundChanged,
                    ),
                    CustomSliderWidget(
                      value: accessibilityValue,
                      text: "Accessibility",
                      onChanged: onAccessibilityChanged,
                    ),
                    CustomSliderWidget(
                      value: buildQualityValue,
                      text: "Build Quality",
                      onChanged: onBuildQualityChanged,
                    ),
                    CustomSliderWidget(
                      value: versatilityValue,
                      text: "Versatility",
                      onChanged: onVersatilityChanged,
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
      ),
    );
  }
}
