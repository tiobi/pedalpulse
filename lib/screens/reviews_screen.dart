import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/comment_model.dart';
import '../models/pedal_model.dart';
import '../services/firebase/pedal_firestore_methods.dart';
import '../utils/managers/color_manager.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/admob_banner_ad_widget.dart';
import '../widgets/custom_text_button_widget.dart';
import '../widgets/loading_placeholder_widget.dart';
import '../widgets/review_dialog_widget.dart';
import '../widgets/review_widget.dart';

class ReviewsScreen extends StatefulWidget {
  // Updated class name
  final PedalModel pedal; // Updated variable name
  const ReviewsScreen({Key? key, required this.pedal})
      : super(key: key); // Updated constructor

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  // Updated class name
  final List<CommentModel> _reviews = []; // Updated type
  final int _batch = 10;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late PedalModel _pedal; // Updated variable name
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch initial reviews when the screen loads
    _pedal = widget.pedal; // Updated variable name
    fetchData();
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  bool isMoreReviewsAvailable() {
    return _reviews.length < _pedal.commentsCount; // Updated variable name
  }

  Future<void> fetchData() async {
    toggleLoading();
    Query query = _firestore
        .collection('pedals') // Updated collection name
        .doc(_pedal.uid) // Updated variable name
        .collection('reviews') // Updated collection name
        .orderBy('createdAt', descending: true);

    if (_reviews.isNotEmpty) {
      // Load more reviews using the last likesCount as the startAfter value
      query = query.startAfter([_reviews.last.createdAt]);
    }

    // Fetch the next 10 reviews
    final reviews = await query.limit(_batch).get().then((value) => value.docs
        .map((e) => CommentModel.fromMap(
            e.data() as Map<String, dynamic>)) // Updated type
        .toList());

    setState(() {
      _reviews.addAll(reviews);
    });
    toggleLoading();
  }

  void getUpdatedPedal() async {
    PedalModel pedal = await PedalFirestoreMethods()
        .getPedalByUid(pedalUid: _pedal.uid); // Updated function name

    setState(() {
      _pedal = pedal; // Updated variable name
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStringManager.reviews), // Updated title
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
                        Text(AppStringManager.addAReview), // Updated text
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
                  builder: (context) => ReviewDialogWidget(
                    pedal: _pedal, // Updated variable name
                  ),
                );
                // update reviews count
                setState(() {
                  _reviews.clear();
                  fetchData();
                });
              },
            ),

            // Reviews
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                CommentModel review = _reviews[index]; // Updated type
                return ReviewWidget(
                  // Updated widget name
                  pedal: _pedal, // Updated variable name
                  comment: review, // Updated variable name
                  updateReview: getUpdatedPedal, // Updated function name
                );
              },
            ),
            _isLoading
                ? const LoadingPlaceholderWidget()
                : isMoreReviewsAvailable()
                    ? Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 16.0),
                            child: CustomTextButtonWidget(
                              onTap: fetchData,
                              placeholder: AppStringManager
                                  .seeMoreReviews, // Updated text
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
