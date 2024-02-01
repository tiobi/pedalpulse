import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedalpulse/models/user_model.dart';
import 'package:pedalpulse/responsive/desktop_layout.dart';
import 'package:pedalpulse/responsive/mobile_layout.dart';
import 'package:pedalpulse/responsive/responsive_layout.dart';
import 'package:pedalpulse/screens/comments_screen.dart';
import 'package:pedalpulse/screens/forgot_password_screen.dart';
import 'package:pedalpulse/screens/home_screen.dart';
import 'package:pedalpulse/screens/reviews_screen.dart';
import 'package:pedalpulse/screens/sign_up_screen.dart';
import 'package:pedalpulse/screens/upload_post_screen.dart';

import '../../models/pedal_model.dart';
import '../../models/post_model.dart';
import '../../screens/add_post_screen.dart';
import '../../screens/feed_screen.dart';
import '../../screens/image_details_screen.dart';
import '../../screens/mobile_web_screen.dart';
import '../../screens/pedal_details_screen.dart';
import '../../screens/post_details_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/search_screen.dart';
import '../../screens/sign_in_screen.dart';
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
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.feed:
        return MaterialPageRoute(
            builder: (_) => const FeedScreen(),
            settings: RouteSettings(arguments: settings.arguments));
      case Routes.uploadPost:
        return MaterialPageRoute(builder: (_) => const UploadPostScreen());
      case Routes.search:
        return MaterialPageRoute(
            builder: (_) =>
                SearchScreen(isSelectable: settings.arguments as bool));
      case Routes.profile:
        return MaterialPageRoute(
            builder: (_) => ProfileScreen(
                  otherUser: settings.arguments as UserModel,
                ));
      case Routes.pedalDetails:
        return MaterialPageRoute(
            builder: (_) =>
                PedalDetailsScreen(pedal: settings.arguments as PedalModel));
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
