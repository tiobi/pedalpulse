import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pedalpulse/models/featured_post_model.dart';
import 'package:pedalpulse/services/firebase/featured_post_firestore_methods.dart';
import 'package:pedalpulse/widgets/loading_placeholder_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/managers/color_manager.dart';

class FeaturedPostsPageviewWidget extends StatefulWidget {
  final List<FeaturedPostModel> featuredPosts;
  const FeaturedPostsPageviewWidget({Key? key, required this.featuredPosts})
      : super(key: key);

  @override
  _FeaturedPostsPageviewWidgetState createState() =>
      _FeaturedPostsPageviewWidgetState();
}

class _FeaturedPostsPageviewWidgetState
    extends State<FeaturedPostsPageviewWidget> {
  final PageController _pageController = PageController();
  Timer? _timer;
  bool _isTapped = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  void _onPostTapped(FeaturedPostModel featuredPost) async {
    setState(() {
      _isTapped = true;
      _timer?.cancel();
    });

    _launchUrl(featuredPost.postUrl);
    FeaturedPostFirestoreMethods().onFeaturedPostVisited(
      postUid: featuredPost.uid,
    );
  }

  void startTimer() {
    // Create a repeating timer that runs every 3 seconds
    if (!_isTapped) {
      _timer = Timer.periodic(
        const Duration(seconds: 5),
        (Timer timer) {
          // Move to the next page (or the first page if already on the last page)
          _currentPage = (_currentPage + 1) % widget.featuredPosts.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;

    return SizedBox(
      width: width,
      height: width * 2 / 3,
      child: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _isTapped
                      ? _onPostTapped(widget.featuredPosts[index])
                      : setState(() {
                          _isTapped = true;
                          _timer?.cancel();
                        });
                },
                child: Stack(
                  children: [
                    Container(
                      color: ColorManager.primaryColorLight,
                      child: CachedNetworkImage(
                        imageUrl: widget.featuredPosts[index].imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const LoadingPlaceholderWidget(),
                      ),
                    ),
                    _isTapped
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black.withOpacity(0.7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Visit Website",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isTapped = false;
                                      startTimer();
                                    });
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: ColorManager.appPrimaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            },
            itemCount: widget.featuredPosts.length,
            controller: _pageController,
            onPageChanged: (_) {
              setState(() {
                _isTapped = false;
              });
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: widget.featuredPosts.length > 1
                ? _buildIndicator()
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.featuredPosts.length, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? ColorManager.appPrimaryColor
                : Colors.grey,
          ),
        );
      }),
    );
  }
}
