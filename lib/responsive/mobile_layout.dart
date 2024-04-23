import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pedalpulse/features/featured/presentation/pages/featured_page.dart';
import 'package:pedalpulse/features/upload/presentation/pages/upload_page.dart';
import 'package:pedalpulse/features/user/presentation/pages/profile_page.dart';
import 'package:pedalpulse/utils/managers/color_manager.dart';

import '../features/featured/presentation/pages/feed_page.dart';
import '../features/search/presentation/pages/search_page.dart';

class MobileLayout extends StatefulWidget {
  final int? initialIndex;
  const MobileLayout({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;
    _pageController = PageController(initialPage: widget.initialIndex ?? 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onNavigationTapped(int page) {
    if (page == 2) {
      showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => const UploadPage(),
      );
      return;
    }
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    if (page == 2) {
      return;
    } else {
      setState(() {
        _currentIndex = page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: tabItems,
      ),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorManager.backgroundColorLight,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        items: bottomNavigationBarItems,
        onTap: onNavigationTapped,
        currentIndex: _currentIndex,
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

const bottomNavigationBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined, color: Colors.black),
    label: '',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.feed_outlined, color: Colors.black),
    label: '',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.add_circle_outline, color: Colors.black),
    label: '',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.search_outlined, color: Colors.black),
    label: '',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outlined, color: Colors.black),
    label: '',
  ),
];
