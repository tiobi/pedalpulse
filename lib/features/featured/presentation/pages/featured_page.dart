import 'package:flutter/material.dart';
import 'package:pedalpulse/features/featured/presentation/widgets/Side_scroll_pedal_list_view_widget.dart';
import 'package:provider/provider.dart';

import '../../../../injection_container.dart';
import '../../../../utils/managers/asset_manager.dart';
import '../../../../utils/managers/color_manager.dart';
import '../../../banner/presentation/providers/banner_provider.dart';
import '../../../pedals/presentation/providers/pedal_provider.dart';
import '../../../posts/presentation/providers/post_provider.dart';
import '../widgets/post_list_view_widget.dart';

class FeaturedPage extends StatelessWidget {
  const FeaturedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BannerProvider bannersProvider = getIt<BannerProvider>();
    final PostProvider postProvider = getIt<PostProvider>();
    // final PedalProvider pedalProvider = getIt<PedalProvider>();
    final PedalProvider pedalProvider = Provider.of<PedalProvider>(context);

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //TODO: BannerWidget

            SideScrollPedalListViewWidget(
              title: "Popular Pedals",
              pedals: pedalProvider.popularPedals,
              isLoading: pedalProvider.popularPedalsLoading,
            ),
            SideScrollPedalListViewWidget(
              title: "Recent Pedals",
              pedals: pedalProvider.recentPedals,
              isLoading: pedalProvider.recentPedalsLoading,
            ),
            PostListViewWidget(
              title: "Popular Posts",
              posts: postProvider.popularPosts,
            ),
            PostListViewWidget(
              title: "Recent Posts",
              posts: postProvider.recentPosts,
            ),
            const SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
