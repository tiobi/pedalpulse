import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_text_button_widget.dart';
import 'package:pedalpulse/features/user/constants/user_string.dart';
import 'package:pedalpulse/injection_container.dart';

import '../../../../core/common/providers/app_size_provider.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/user_provider.dart';

class ProfilePage extends HookWidget {
  ProfilePage({super.key});

  final UserProvider userProvider = getIt<UserProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildProfile(userProvider.user),
    );
  }

  Widget _buildProfile(UserEntity? user) {
    return user == null
        ? Center(
            child: Row(
              children: [
                const Text(UserString.unableToLoadUser),
                CustomTextButtonWidget(
                  placeholder: UserString.reload,
                  onTap: () {
                    userProvider.getUser();
                  },
                )
              ],
            ),
          )
        : _buildContents(user);
  }

  Widget _buildContents(UserEntity user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileSection(user),
          _buildPostsSection(),
          _buildOptionsOptions(),
        ],
      ),
    );
  }

  Widget _buildProfileSection(UserEntity user) {
    final Size size = GetIt.instance<AppSizeProvider>().size;
    return Stack(
      children: [
        // Background Image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.network(
            user.backgroundImageUrl,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.width * 0.5,
            ),
            // Profile Image and User Info
            CircleAvatar(
              radius: 85,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(user.profileImageUrl),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Joined At: ${DateFormat('dd/MM/yyyy').format(user.joinedAt)}',
                )
              ],
            ),
            Text(user.bio),
          ],
        ),
      ],
    );
  }

  Widget _buildPostsSection() {
    return const SizedBox();
  }

  Widget _buildOptionsOptions() {
    return Column(
      children: [
        CustomTextButtonWidget(
          placeholder: "Edit Profile",
          onTap: () {},
        ),
      ],
    );
  }
}