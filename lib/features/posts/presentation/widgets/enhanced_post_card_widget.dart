import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes/routes.dart';
import '../../../../core/common/managers/asset_manager.dart';
import '../../../../core/common/managers/color_manager.dart';
import '../../../../core/common/widgets/loading_placeholder_widget.dart';
import '../../../user/presentation/widgets/user_avatar_widget.dart';
import '../../domain/entities/post_entity.dart';
import '../providers/post_provider.dart';
import '../state/post_state.dart';

class EnhancedPostCardWidget extends StatelessWidget {
  final PostEntity post;
  final String? currentUserUid;
  final VoidCallback? onTap;
  final bool showInteractions;

  const EnhancedPostCardWidget({
    super.key,
    required this.post,
    this.currentUserUid,
    this.onTap,
    this.showInteractions = true,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isLiked = currentUserUid != null && 
        post.likes.contains(currentUserUid);

    return Consumer<PostProvider>(
      builder: (context, postProvider, _) {
        final bool isProcessing = postProvider.isProcessingInteraction;

        return GestureDetector(
          onTap: onTap ?? () {
            Navigator.pushNamed(context, Routes.postDetails, arguments: post);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 1),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: ColorManager.primaryColorLight,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildContent(size),
                if (showInteractions) _buildInteractions(postProvider, isLiked, isProcessing),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          UserAvatarWidget(
            userUid: post.userUid,
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatDate(post.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (currentUserUid == post.userUid)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDialog();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Post'),
                    ],
                  ),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (post.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              post.description,
              style: const TextStyle(fontSize: 16),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (post.imageUrls.isNotEmpty) _buildImageCarousel(size),
        if (post.pedalList.isNotEmpty) _buildPedalTags(),
      ],
    );
  }

  Widget _buildImageCarousel(Size size) {
    if (post.imageUrls.length == 1) {
      return _buildSingleImage(post.imageUrls.first, size);
    }

    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: post.imageUrls.length,
        itemBuilder: (context, index) {
          return _buildSingleImage(post.imageUrls[index], size);
        },
      ),
    );
  }

  Widget _buildSingleImage(String imageUrl, Size size) {
    return Container(
      width: size.width,
      height: 300,
      color: Colors.grey[200],
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const LoadingPlaceholderWidget(),
        errorWidget: (context, url, error) => Center(
          child: Image.asset(
            ImageAssetManager.appLogoWhite,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildPedalTags() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: post.pedalList.take(3).map((pedal) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ColorManager.primaryColorLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              pedal.name,
              style: const TextStyle(
                fontSize: 12,
                color: ColorManager.primaryColorDark,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInteractions(PostProvider postProvider, bool isLiked, bool isProcessing) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${post.likesCount} likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              Text(
                '${post.commentsCount} comments',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              Text(
                '${post.views} views',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: isLiked ? 'Unlike' : 'Like',
                  color: isLiked ? Colors.red : Colors.grey[600]!,
                  onPressed: isProcessing || currentUserUid == null 
                      ? null 
                      : () => _handleLikeToggle(postProvider, isLiked),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: 'Comment',
                  color: Colors.grey[600]!,
                  onPressed: () {
                    // Navigate to post details with focus on comments
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: Colors.grey[600]!,
                  onPressed: () {
                    // Implement share functionality
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLikeToggle(PostProvider postProvider, bool isCurrentlyLiked) {
    if (currentUserUid == null) return;

    if (isCurrentlyLiked) {
      postProvider.unlikePost(
        postUid: post.uid,
        userUid: currentUserUid!,
      );
    } else {
      postProvider.likePost(
        postUid: post.uid,
        userUid: currentUserUid!,
      );
    }
  }

  void _showDeleteDialog() {
    // TODO: Implement delete dialog
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}