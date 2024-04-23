import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedalpulse/features/auth/presentation/pages/sign_in_page.dart';
import 'package:pedalpulse/features/auth/presentation/pages/sign_up_page.dart';
import 'package:pedalpulse/features/featured/presentation/pages/featured_page.dart';
import 'package:pedalpulse/features/featured/presentation/pages/feed_page.dart';
import 'package:pedalpulse/features/user/presentation/pages/profile_page.dart';
import 'package:pedalpulse/responsive/desktop_layout.dart';
import 'package:pedalpulse/responsive/mobile_layout.dart';
import 'package:pedalpulse/responsive/responsive_layout.dart';
import 'package:pedalpulse/screens/comments_screen.dart';
import 'package:pedalpulse/screens/reviews_screen.dart';
import 'package:pedalpulse/screens/upload_post_screen.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../models/pedal_model.dart';
import '../../models/post_model.dart';
import '../../screens/add_post_screen.dart';
import '../../screens/image_details_screen.dart';
import '../../screens/mobile_web_screen.dart';
import '../../screens/post_details_screen.dart';
import '../../screens/search_screen.dart';
import '../../screens/upload_screen.dart';

class Routes {
  static const String splash = '/';
  static const String mobileLayout = '/mobileLayout';
  static const String desktopLayout = '/desktopLayout';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';

  static const String home = '/home';
  static const String feed = '/feed';
  static const String uploadPost = '/uploadPost';
  static const String search = '/search';
  static const String profile = '/profile';

  static const String pedalDetails = '/pedalDetails';
  static const String postDetails = '/postDetails';
  static const String imageDetails = '/imageDetails';

  static const String upload = '/upload';
  static const String addPost = '/add_post';
  static const String comments = '/comments';
  static const String reviews = '/reviews';
}

class RouteManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mobileLayout:
        return MaterialPageRoute(
            builder: (_) =>
                MobileLayout(initialIndex: settings.arguments as int?));
      case Routes.desktopLayout:
        return MaterialPageRoute(builder: (_) => const DesktopLayout());
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const FeaturedPage());
      case Routes.feed:
        return MaterialPageRoute(
            builder: (_) => const FeedPage(),
            settings: RouteSettings(arguments: settings.arguments));
      case Routes.uploadPost:
        return MaterialPageRoute(builder: (_) => const UploadPostScreen());
      case Routes.search:
        return MaterialPageRoute(
            builder: (_) =>
                SearchScreen(isSelectable: settings.arguments as bool));
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());

      case Routes.postDetails:
        return MaterialPageRoute(
            builder: (_) =>
                PostDetailsScreen(post: settings.arguments as PostModel));
      case Routes.imageDetails:
        return MaterialPageRoute(
            builder: (_) =>
                ImageDetailsScreen(widget: settings.arguments as Widget));
      case Routes.upload:
        return MaterialPageRoute(builder: (_) => const UploadScreen());
      case Routes.addPost:
        return MaterialPageRoute(builder: (_) => const AddPostScreen());

      case Routes.comments:
        return MaterialPageRoute(
            builder: (_) =>
                CommentsScreen(post: settings.arguments as PostModel));

      case Routes.reviews:
        return MaterialPageRoute(
            builder: (_) =>
                ReviewsScreen(pedal: settings.arguments as PedalModel));

      // On Error
      default:
        return MaterialPageRoute(builder: (_) {
          if (kIsWeb) {
            return const MobileWebScreen();
          }
          return const ResponsiveLayout(
            mobileLayout: MobileLayout(initialIndex: 0),
            desktopLayout: DesktopLayout(),
          );
        });
    }
  }
}
