import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 3rd party packages
///
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:pedalpulse/core/common/providers/app_size_provider.dart';
import 'package:pedalpulse/features/posts/presentation/providers/post_provider.dart';
import 'package:pedalpulse/features/search/presentation/providers/request_provider.dart';
import 'package:pedalpulse/features/search/presentation/providers/search_provider.dart';
import 'package:pedalpulse/injection_container.dart';
import 'package:pedalpulse/utils/managers/string_manager.dart';
import 'package:provider/provider.dart';

import '../core/routes/routes.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

import '../features/banner/presentation/providers/banner_provider.dart';
import '../features/pedals/presentation/providers/pedal_provider.dart';
import '../features/upload/presentation/providers/upload_provider.dart';

/// Models and Providers
///
import '../features/user/presentation/providers/user_provider.dart';
import '../providers/user_likes_provider_depr.dart';

import '../responsive/desktop_layout.dart';
import '../responsive/mobile_layout.dart';
import '../responsive/responsive_layout.dart';
import '../screens/mobile_web_screen.dart';

/// Utils
///
import '../utils/managers/theme_manager.dart';

class PedalPulseApp extends StatelessWidget {
  const PedalPulseApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => getIt<UserProvider>(),
        ),
        ChangeNotifierProvider<UserLikesProviderDepr>(
          create: (_) => UserLikesProviderDepr(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => getIt<AuthProvider>(),
        ),
        ChangeNotifierProvider<AppSizeProvider>(
          create: (_) => getIt<AppSizeProvider>(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => getIt<SearchProvider>(),
        ),
        ChangeNotifierProvider<RequestProvider>(
          create: (_) => getIt<RequestProvider>(),
        ),
        ChangeNotifierProvider<UploadProvider>(
          create: (_) => getIt<UploadProvider>(),
        ),
        ChangeNotifierProvider<PedalProvider>(
          create: (_) => getIt<PedalProvider>(),
        ),
        ChangeNotifierProvider<PostProvider>(
          create: (_) => getIt<PostProvider>(),
        ),
      ],
      child: MaterialApp(
        title: AppStringManager.appTitle,
        theme: ThemeManager.getThemeData(),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        /*
        Do not change the order of the following widgets.
        If mobile screen comes before kIsWeb, 
        some of the packages will not work properly.
         */
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (kIsWeb) {
              return const MobileWebScreen();
            }
            if (!snapshot.hasData) {
              return SignInPage();
            } else {
              /// Initialize all the providers here.
              ///
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
                  postProvider.recentPosts.isEmpty) {
                postProvider.getFeaturedPosts();
              }

              return const ResponsiveLayout(
                mobileLayout: MobileLayout(initialIndex: 0),
                desktopLayout: DesktopLayout(),
              );
            }
          },
        ),
        onGenerateRoute: ((settings) => RouteManager.generateRoute(settings)),
      ),
    );
  }
}
