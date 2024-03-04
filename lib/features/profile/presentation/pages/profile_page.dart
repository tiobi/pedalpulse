import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pedalpulse/injection_container.dart';

import '../../../user/domain/entities/user_entity.dart';
import '../../../user/presentation/providers/user_provider.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = getIt<UserProvider>();
    return Scaffold(
      body: userProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildProfile(userProvider.user),
    );
  }

  Widget _buildProfile(UserEntity? user) {
    return user == null
        ? const Center(
            child: Text('No user found'),
          )
        : Column(
            children: [
              Text(user.email),
            ],
          );
  }
}
