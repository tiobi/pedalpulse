import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 3rd party packages
///
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:pedalpulse/injection_container.dart';
import 'package:pedalpulse/utils/managers/string_manager.dart';
import 'package:provider/provider.dart';

import '../core/routes/routes.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

/// Models and Providers
///
import '../features/user/presentation/providers/user_provider.dart';
import '../providers/pedal_provider.dart';
import '../providers/user_likes_provider.dart';

import '../responsive/desktop_layout.dart';
import '../responsive/mobile_layout.dart';
import '../responsive/responsive_layout.dart';
import '../screens/mobile_web_screen.dart';

/// Utils
///
import '../utils/managers/theme_manager.dart';

class PedalPulseApp extends StatelessWidget {
  const PedalPulseApp({Key? key}) : super(key: key);

  /// TODO: make dependency injection
  ///
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      /// TODO: make common provider list
      ///
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => getIt<UserProvider>(),
        ),
        ChangeNotifierProvider<PedalProvider>(
          create: (_) => PedalProvider(),
        ),
        ChangeNotifierProvider<UserLikesProvider>(
          create: (_) => UserLikesProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => getIt<AuthProvider>(),
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

  // final _router = GoRouter(
  //   observers: [FirebaseAnalyticsObserver(analytics: analytics)],
  //   routes: [
  //     GoRoute(
  //       path: 'signin',
  //       pageBuilder: (context, state) {
  //         return const SignInScreen();
  //       },
  //     ),
  //   ],
  // );
}
