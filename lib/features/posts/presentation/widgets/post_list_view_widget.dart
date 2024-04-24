import 'package:flutter/material.dart';

import '../../../../config/routes/routes.dart';
import '../../../auth/presentation/widgets/custom_text_button_widget.dart';
import '../../domain/entities/post_entity.dart';
import 'post_card_widget.dart';

class PostListViewWidget extends StatelessWidget {
  final String title;
  final List<PostEntity> posts;
  const PostListViewWidget({Key? key, required this.title, required this.posts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                posts.isEmpty || posts.length < 3
                    ? const SizedBox()
                    : CustomTextButtonWidget(
                        placeholder: "See All",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.feed,
                          );
                        },
                      )
              ],
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: ((context, index) {
              return PostCardWidget(post: posts[index]);
            }),
          ),
        ],
      ),
    );
  }
}
