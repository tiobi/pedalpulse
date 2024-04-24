import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pedalpulse/responsive/hidable_bottom_navigation_bar.dart';
import 'package:pedalpulse/responsive/mobile_layout.dart';
import 'package:pedalpulse/widgets/safe_area_padding_widget.dart';

import '../../domain/entities/post_entity.dart';

class PostDetailsPage extends HookWidget {
  final PostEntity post;
  const PostDetailsPage({
    required this.post,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = useScrollController();

    return Scaffold(
      bottomNavigationBar: HidableBottomNavigationBar(
        scrollController: scrollController,
        items: bottomNavigationBarItems,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SafeAreaPaddingWidget(),
            _buildImageSection(),
            _buildDescriptionSection(),
            _buildPedalListSection(context),
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return const Column(
      children: [],
    );
  }

  Widget _buildDescriptionSection() {
    return Container();
  }

  Widget _buildPedalListSection(BuildContext context) {
    return Container();
  }

  Widget _buildCommentSection() {
    return Container();
  }
}
