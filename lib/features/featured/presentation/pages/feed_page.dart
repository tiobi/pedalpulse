import 'package:flutter/material.dart';
import 'package:pedalpulse/features/posts/presentation/providers/post_provider.dart';
import 'package:provider/provider.dart';

import '../../../../utils/managers/string_manager.dart';
import '../../../../widgets/post_card_widget.dart';
import '../../../posts/domain/entities/post_entity.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostProvider postProvider = Provider.of<PostProvider>(context);
    final List<PostEntity> posts = postProvider.feedPosts;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(AppStringManager.posts),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCardWidget(
                    post: post,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
