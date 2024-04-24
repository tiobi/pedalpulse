import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/managers/asset_manager.dart';
import '../../../../core/common/managers/color_manager.dart';
import '../../../../core/common/widgets/loading_placeholder_widget.dart';
import '../../../../core/routes/routes.dart';
import '../../domain/entities/post_entity.dart';

class PostCardWidget extends StatefulWidget {
  final PostEntity post;
  const PostCardWidget({
    super.key,
    required this.post,
  });

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.postDetails,
            arguments: widget.post);
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ColorManager.primaryColorLight, width: 1),
          ),
        ),
        height: 150,
        width: size.width,
        padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: ColorManager.primaryColorLight,
                height: 120,
                width: 120,
                child: widget.post.imageUrls.isEmpty
                    ? Center(
                        child: Image.asset(
                          ImageAssetManager.appLogoWhite,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.post.imageUrls[0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const LoadingPlaceholderWidget(),
                      ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              width: size.width - 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  UserAvatarWidget(
                    userUid: widget.post.userUid,
                  ),
                  Text(
                      " ${widget.post.likesCount} Likes | ${widget.post.commentsCount} Comments"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
