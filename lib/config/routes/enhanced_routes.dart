import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider_new.dart';
import '../../features/user/presentation/providers/user_provider_new.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/user/presentation/pages/user_profile_page.dart';
import '../../injection_container.dart';

class EnhancedRoutes {
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String userProfile = '/user-profile';
  static const String home = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<AuthProviderNew>(),
            child: const SignInPage(),
          ),
        );

      case signUp:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<AuthProviderNew>(),
            child: const SignUpPage(),
          ),
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => getIt<AuthProviderNew>(),
            child: const ForgotPasswordPage(),
          ),
        );

      case userProfile:
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => getIt<AuthProviderNew>(),
              ),
              ChangeNotifierProvider(
                create: (_) => getIt<UserProviderNew>(),
              ),
            ],
            child: const UserProfilePage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }

  static void navigateToSignIn(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      signIn,
      (route) => false,
    );
  }

  static void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, signUp);
  }

  static void navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, forgotPassword);
  }

  static void navigateToUserProfile(BuildContext context) {
    Navigator.pushNamed(context, userProfile);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      home,
      (route) => false,
    );
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  static void goBack(BuildContext context) {
    if (canPop(context)) {
      Navigator.pop(context);
    }
  }
}

class RouteGuard {
  static bool isAuthRequired(String routeName) {
    return [userProfile].contains(routeName);
  }

  static String? checkAuthRedirect(String routeName, bool isAuthenticated) {
    if (isAuthRequired(routeName) && !isAuthenticated) {
      return EnhancedRoutes.signIn;
    }
    
    if ([EnhancedRoutes.signIn, EnhancedRoutes.signUp].contains(routeName) && 
        isAuthenticated) {
      return EnhancedRoutes.home;
    }
    
    return null;
  }
}