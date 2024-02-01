import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../models/featured_post_model.dart';

import '../models/pedal_model.dart';
import '../models/post_model.dart';
import '../models/search_option_model.dart';
import '../screens/profile_screen.dart';
import '../services/firebase/featured_post_firestore_methods.dart';
import '../services/firebase/pedal_firestore_methods.dart';
import '../services/firebase/post_firestore_methods.dart';
import '../utils/managers/asset_manager.dart';
import '../utils/managers/color_manager.dart';
import '../widgets/admob_banner_ad_widget.dart';
import '../widgets/featured_posts_pageview_widget.dart';
import '../widgets/loading_placeholder_widget.dart';
import '../widgets/post_listview_widget.dart';
import '../widgets/sidescroll_pedal_listview_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final bool _isLoading = false;

  List<FeaturedPostModel> featuredPosts = [];
  List<PostModel> recentPosts = [];
  List<PostModel> popularPosts = [];
  List<PedalModel> topRatedPedals = [];
  List<PedalModel> popularPedals = [];

  @override
  void initState() {
    super.initState();
    getFeaturedPosts();
    getRecentPosts();
    getPopularPosts();
    getPopularPedals();
    getTopRatedPedals();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getFeaturedPosts() async {
    List<FeaturedPostModel> posts =
        await FeaturedPostFirestoreMethods().getFeaturedPosts();

    if (mounted) {
      setState(() {
        featuredPosts = posts;
      });
    }
  }

  void getRecentPosts() async {
    List<PostModel> posts =
        await PostFirestoreMethods().getRecentPosts(limit: 3);

    if (mounted) {
      setState(() {
        recentPosts = posts;
      });
    }
  }

  void getPopularPosts() async {
    List<PostModel> posts =
        await PostFirestoreMethods().getPopularPosts(limit: 3);

    if (mounted) {
      setState(() {
        popularPosts = posts;
      });
    }
  }

  void getPopularPedals() async {
    List<PedalModel> pedals = await PedalFirestoreMethods().getPopularPedals();

    if (mounted) {
      setState(() {
        popularPedals = pedals;
      });
    }
  }

  void getTopRatedPedals() async {
    List<PedalModel> pedals = await PedalFirestoreMethods().getTopRatedPedals();

    if (mounted) {
      setState(() {
        topRatedPedals = pedals;
      });
    }
  }

  void onAvatarTapped() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return const ProfileScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorManager.backgroundColorLight,
        forceMaterialTransparency: true,
        title: Image.asset(
          ImageAssetManager.appLogoBlack,
          fit: BoxFit.cover,
          height: 30,
        ),
        actions: const [
          // Padding(
          //   padding: const EdgeInsets.only(right: 15),
          //   child: IconButton(
          //     icon: const Icon(
          //       Icons.notifications_none_outlined,
          //       color: Colors.black,
          //       size: 30,
          //     ),
          //     onPressed: () {},
          //   ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: GestureDetector(
          //     onTap: onAvatarTapped,
          //     child: const Icon(
          //       Icons.menu,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: _isLoading
            ? const Center(child: LoadingPlaceholderWidget())
            : Column(
                children: [
                  FeaturedPostsPageviewWidget(
                    featuredPosts: featuredPosts,
                  ),
                  SidescrollPedalListviewWidget(
                    title: "Popular Pedals",
                    pedalList: popularPedals,
                  ),
                  SidescrollPedalListviewWidget(
                    title: "Recently Added",
                    pedalList: topRatedPedals,
                  ),
                  const AdMobBannerAdWidget(adType: AdType.largeBanner),
                  PostListviewWidget(
                    title: "Recent Posts",
                    postList: recentPosts,
                    searchOption: SearchOptionModel(
                      searchOption: SearchOption.RECENT,
                    ),
                  ),
                  PostListviewWidget(
                    title: "Popular Posts",
                    postList: popularPosts,
                    searchOption: SearchOptionModel(
                      searchOption: SearchOption.POPULAR,
                    ),
                  ),
                  const AdMobBannerAdWidget(
                    adType: AdType.mediumRectangle,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
      ),
    );
  }
}
