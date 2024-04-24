import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pedalpulse/features/pedals/presentation/widgets/side_scroll_pedal_list_view_widget.dart';
import 'package:pedalpulse/responsive/hidable_bottom_navigation_bar.dart';
import 'package:pedalpulse/responsive/mobile_layout.dart';
import 'package:pedalpulse/core/common/managers/string_manager.dart';

import '../../../../core/common/managers/asset_manager.dart';
import '../../../../core/common/managers/color_manager.dart';
import '../../../../core/common/widgets/safe_area_padding_widget.dart';
import '../../../user/presentation/widgets/user_avatar_widget.dart';
import '../../domain/entities/post_entity.dart';
import '../widgets/image_pageview_indicator_widget.dart';

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
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        post.imageUrls.isEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                color: ColorManager.primaryColorLight,
                child: Center(
                  child: Image.asset(
                    ImageAssetManager.appLogoWhite,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : ImagePageviewIndicatorWidget(
                imageUrls: post.imageUrls,
              ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            post.description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          UserAvatarWidget(userUid: post.userUid),
        ],
      ),
    );
  }

  Widget _buildPedalListSection(BuildContext context) {
    return SideScrollPedalListViewWidget(
      title: AppStringManager.pedalsUsed,
      pedals: post.pedalList,
      isLoading: false,
    );
  }
}
