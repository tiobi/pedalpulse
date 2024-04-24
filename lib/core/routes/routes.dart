import 'package:flutter/material.dart';
import 'package:pedalpulse/features/posts/presentation/pages/post_details_page.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/pedals/domain/entities/pedal_entity.dart';
import '../../features/pedals/presentation/pages/pedal_details_page.dart';
import '../../features/posts/domain/entities/post_entity.dart';

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
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());

      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpPage());

      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());

      case Routes.home:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Center(child: Text('Home'))));

      case Routes.pedalDetails:
        return MaterialPageRoute(
          builder: (_) => PedalDetailsPage(
            pedal: settings.arguments as PedalEntity,
          ),
        );
      case Routes.postDetails:
        return MaterialPageRoute(
          builder: (_) => PostDetailsPage(
            post: settings.arguments as PostEntity,
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
