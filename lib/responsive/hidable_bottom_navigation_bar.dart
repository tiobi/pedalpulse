import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pedalpulse/features/featured/presentation/pages/featured_page.dart';
import 'package:pedalpulse/features/featured/presentation/pages/feed_page.dart';
import 'package:pedalpulse/features/search/presentation/pages/search_page.dart';
import 'package:pedalpulse/features/upload/presentation/pages/upload_page.dart';
import 'package:pedalpulse/features/user/presentation/pages/profile_page.dart';
import 'package:pedalpulse/utils/managers/color_manager.dart';

import '../screens/feed_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/upload_post_screen.dart';
import '../screens/upload_screen.dart';
import '../utils/managers/route_manager.dart';

class HidableBottomNavigationBar extends StatefulWidget {
  final ScrollController scrollController;
  final List<BottomNavigationBarItem> items;
  final void Function(int)? onTap;
  final int currentIndex;

  const HidableBottomNavigationBar({
    super.key,
    required this.scrollController,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
  });

  @override
  _HidableBottomNavigationBarState createState() =>
      _HidableBottomNavigationBarState();
}

class _HidableBottomNavigationBarState
    extends State<HidableBottomNavigationBar> {
  bool _isVisible = true;
  double _bottomBarHeight = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isVisible = false;
      });
    }
    if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isVisible = true;
      });
    }
  }

  void onNavigationTapped(int page) {
    if (page == 2) {
      showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => const UploadPostScreen(),
      );
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.mobileLayout,
      arguments: page,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      _bottomBarHeight = 0;
    } else {
      _bottomBarHeight = kBottomNavigationBarHeight +
          MediaQuery.of(context).padding.bottom +
          3;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _bottomBarHeight,
      child: Center(
        child: BottomNavigationBar(
          backgroundColor: ColorManager.backgroundColorLight,
          type: BottomNavigationBarType.fixed,
          items: widget.items,
          onTap: onNavigationTapped,
          currentIndex: widget.currentIndex,
        ),
      ),
    );
  }
}

List<Widget> tabItems = <Widget>[
  const FeaturedPage(),
  const FeedPage(),
  const UploadPage(),
  const SearchPage(),
  ProfilePage(),
];

const List<String> tabRoutes = [
  Routes.home,
  Routes.feed,
  Routes.uploadPost,
  Routes.search,
  Routes.profile,
];
