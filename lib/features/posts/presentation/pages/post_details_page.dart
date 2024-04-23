import 'package:flutter/material.dart';
import 'package:pedalpulse/responsive/hidable_bottom_navigation_bar.dart';
import 'package:pedalpulse/responsive/mobile_layout.dart';

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: HidableBottomNavigationBar(
        scrollController: ScrollController(),
        items: bottomNavigationBarItems,
      ),
      body: const Center(
        child: Text("Post Details Page"),
      ),
    );
  }
}
