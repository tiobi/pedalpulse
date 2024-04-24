import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pedalpulse/features/pedals/domain/entities/pedal_entity.dart';
import 'package:pedalpulse/features/posts/presentation/widgets/post_list_view_widget.dart';
import 'package:pedalpulse/responsive/hidable_bottom_navigation_bar.dart';
import 'package:pedalpulse/responsive/mobile_layout.dart';
import 'package:pedalpulse/widgets/image_pageview_indicator_widget.dart';
import 'package:pedalpulse/widgets/safe_area_padding_widget.dart';
import 'package:provider/provider.dart';

import '../../../../utils/managers/string_manager.dart';
import '../../../posts/domain/entities/post_entity.dart';
import '../../../posts/presentation/providers/post_provider.dart';

class PedalDetailsPage extends HookWidget {
  final PedalEntity pedal;
  const PedalDetailsPage({Key? key, required this.pedal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = useScrollController();

    useEffect(() {
      Provider.of<PostProvider>(context, listen: false)
          .getPostsWithPedal(pedalUid: pedal.uid);
      return null;
    });

    return Scaffold(
      bottomNavigationBar: HidableBottomNavigationBar(
        scrollController: scrollController,
        items: bottomNavigationBarItems,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SafeAreaPaddingWidget(),
            ImagePageviewIndicatorWidget(imageUrls: pedal.imageUrls),
            _buildInfoSection(),
            _buildPostsWithPedalSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      // width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pedal.brand,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            pedal.name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            pedal.category[0],
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            pedal.description,
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              const Spacer(),
              const Text(AppStringManager.foundWrongInfo),
              GestureDetector(
                // onTap: onReportTapped,
                child: const Text(
                  AppStringManager.letUsKnow,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPostsWithPedalSection(BuildContext context) {
    final PostProvider postProvider = Provider.of<PostProvider>(context);
    final List<PostEntity> posts = postProvider.postWithPedal;
    postProvider.getPostsWithPedalUseCase(pedalUid: pedal.uid);

    return posts.isEmpty
        ? const SizedBox()
        : PostListViewWidget(
            title: AppStringManager.pedalboards,
            posts: posts,
          );
  }
}
