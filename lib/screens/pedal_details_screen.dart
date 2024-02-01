import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../layouts/hidable_bottom_navigation_bar.dart';
import '../models/comment_model.dart';
import '../models/pedal_model.dart';
import '../models/post_model.dart';
import '../models/search_option_model.dart';
import '../screens/request_pedal_screen.dart';
import '../services/firebase/pedal_firestore_methods.dart';
import '../services/firebase/post_firestore_methods.dart';
import '../services/firebase/review_firestore_methods.dart';
import '../utils/managers/color_manager.dart';
import '../utils/managers/route_manager.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/admob_banner_ad_widget.dart';
import '../widgets/custom_text_button_widget.dart';
import '../widgets/image_pageview_indicator_widget.dart';
import '../widgets/post_listview_widget.dart';
import '../widgets/review_dialog_widget.dart';
import '../widgets/review_widget.dart';
import '../widgets/safe_area_padding_widget.dart';
import '../responsive/mobile_layout.dart';

class PedalDetailsScreen extends StatefulWidget {
  final PedalModel pedal;
  const PedalDetailsScreen({Key? key, required this.pedal}) : super(key: key);

  @override
  State<PedalDetailsScreen> createState() => _PedalDetailsScreenState();
}

class _PedalDetailsScreenState extends State<PedalDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  List<PostModel> _postList = [];
  late PedalModel _pedal;

  @override
  void initState() {
    super.initState();
    _pedal = widget.pedal;
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void fetchData() async {
    try {
      List<PostModel> postList = [];
      postList = await PostFirestoreMethods()
          .getPostsByPedalUid(pedalUid: _pedal.uid, limit: 3);

      PedalModel pedal =
          await PedalFirestoreMethods().getPedalByUid(pedalUid: _pedal.uid);

      setState(() {
        _postList = postList;
        _pedal = pedal;
      });
    } catch (e) {}
  }

  void getUpdatedPedal() async {
    PedalModel pedal =
        await PedalFirestoreMethods().getPedalByUid(pedalUid: _pedal.uid);

    setState(() {
      _pedal = pedal;
    });
  }

  Future<List<CommentModel>> getFeaturedComments() async {
    final List<CommentModel> featuredComments = await ReviewFirestoreMethods()
        .getFeaturedReviewsByPedalUid(pedalUid: _pedal.uid);

    return featuredComments;
  }

  void onReportTapped() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return RequestPedalScreen(
          pedal: _pedal,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;

    return Scaffold(
      bottomNavigationBar: HidableBottomNavigationBar(
        scrollController: _scrollController,
        items: bottomNavigationBarItems,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SafeAreaPaddingWidget(),
            ImagePageviewIndicatorWidget(imageUrls: _pedal.imageUrls),
            Container(height: 20, color: ColorManager.primaryColorLight),

            // Pedal info and description
            Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _pedal.brand,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _pedal.name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _pedal.category[0],
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _pedal.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      const Text(AppStringManager.foundWrongInfo),
                      GestureDetector(
                        onTap: onReportTapped,
                        child: const Text(
                          AppStringManager.letUsKnow,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const AdMobBannerAdWidget(adType: AdType.largeBanner),
            const SizedBox(
              height: 50,
            ),
            PostListviewWidget(
              postList: _postList,
              title: AppStringManager.pedalboards,
              searchOption: SearchOptionModel(
                searchOption: SearchOption.PEDAL,
                argument: _pedal.uid,
                limit: 3,
              ),
            ),

            const SizedBox(
              height: 50,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    _pedal.commentsCount < 2
                        ? "${_pedal.commentsCount} ${AppStringManager.review}"
                        : "${_pedal.commentsCount} ${AppStringManager.reviews}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: getUpdatedPedal,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                await showCupertinoModalBottomSheet(
                  expand: true,
                  elevation: 100,
                  context: context,
                  builder: (context) => ReviewDialogWidget(
                    pedal: _pedal,
                  ),
                );
                // update comments count
                getUpdatedPedal();
              },
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
                        Text(AppStringManager.addAReview),
                      ],
                    ),
                  ),
                ),
              ),
            ),

// Comments section
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
                      return ReviewWidget(
                        pedal: _pedal,
                        comment: comments[index],
                        showReply: true,
                        updateReview: getUpdatedPedal,
                      );
                    },
                  );
                } else {
                  return const Center(child: Text(AppStringManager.noComments));
                }
              },
            ),

            _pedal.commentsCount > 3
                ? Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                        child: CustomTextButtonWidget(
                          placeholder:
                              "See All ${_pedal.commentsCount} Reviews",
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(Routes.reviews, arguments: _pedal);
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
    );
  }
}
