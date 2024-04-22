import 'package:flutter/material.dart';
import 'package:pedalpulse/providers/user_likes_provider_depr.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({
    Key? key,
    required this.mobileLayout,
    required this.desktopLayout,
  }) : super(key: key);

  @override
  _ResponsiveLayoutState createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    getUserLikes();
  }

  void getUserLikes() {
    UserLikesProviderDepr userLikesProvider =
        Provider.of<UserLikesProviderDepr>(context, listen: false);

    userLikesProvider.setUserLikes();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return widget.mobileLayout;
        } else {
          return widget.desktopLayout;
        }
      },
    );
  }
}
