import 'package:flutter/material.dart';

import '../core/common/providers/app_size_provider.dart';
import '../features/banner/presentation/providers/banner_provider.dart';
import '../features/pedals/presentation/providers/pedal_provider.dart';
import '../features/posts/presentation/providers/post_provider.dart';
import '../features/user/presentation/providers/user_provider.dart';
import '../injection_container.dart';

void initProviders(BuildContext context) {
  UserProvider userProvider = getIt<UserProvider>();
  if (userProvider.user == null) {
    userProvider.getUser();
  }

  AppSizeProvider appSizeProvider = getIt<AppSizeProvider>();
  if (appSizeProvider.size == Size.zero) {
    appSizeProvider.setAppSize(context: context);
  }

  BannerProvider bannerProvider = getIt<BannerProvider>();
  if (bannerProvider.banners.isEmpty) {
    bannerProvider.getBanners(context: context);
  }

  PedalProvider pedalProvider = getIt<PedalProvider>();
  if (pedalProvider.popularPedals.isEmpty ||
      pedalProvider.recentPedals.isEmpty) {
    pedalProvider.getFeaturedPedals();
  }

  PostProvider postProvider = getIt<PostProvider>();
  if (postProvider.popularPosts.isEmpty ||
      postProvider.recentPosts.isEmpty ||
      postProvider.feedPosts.isEmpty) {
    postProvider.initProvider();
  }
}
