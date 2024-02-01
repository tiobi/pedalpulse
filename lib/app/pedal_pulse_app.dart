/// Flutter and Dart packages
///
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 3rd party packages
///
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedalpulse/utils/managers/string_manager.dart';
import 'package:provider/provider.dart';

/// Models and Providers
///
import '../providers/user_provider.dart';
import '../providers/pedal_provider.dart';
import '../providers/user_likes_provider.dart';

/// Screens and Layouts
///
import '../responsive/responsive_layout.dart';
import '../responsive/mobile_layout.dart';
import '../responsive/desktop_layout.dart';
import '../screens/mobile_web_screen.dart';
import '../screens/sign_in_screen.dart';

/// Utils
///
import '../utils/managers/theme_manager.dart';
import '../utils/managers/route_manager.dart';

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
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<PedalProvider>(
          create: (_) => PedalProvider(),
        ),
        ChangeNotifierProvider<UserLikesProvider>(
            create: (_) => UserLikesProvider()),
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
              return const SignInScreen();
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
}
