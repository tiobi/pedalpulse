// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pedalpulse/models/post_model.dart';
import 'package:pedalpulse/widgets/post_card_widget.dart';

import '../models/search_option_model.dart';
import '../utils/managers/route_manager.dart';
import 'custom_text_button_widget.dart';

class PostListviewWidget extends StatefulWidget {
  final List<PostModel> postList;
  final String title;
  final SearchOptionModel? searchOption;
  const PostListviewWidget({
    Key? key,
    required this.postList,
    required this.title,
    this.searchOption,
  }) : super(key: key);

  @override
  State<PostListviewWidget> createState() => _PostListviewWidgetState();
}

class _PostListviewWidgetState extends State<PostListviewWidget> {
  List<PostModel> postList = [];
  @override
  void initState() {
    super.initState();
    postList = widget.postList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                widget.postList.isEmpty || widget.postList.length < 3
                    ? const SizedBox()
                    : CustomTextButtonWidget(
                        placeholder: "See All",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.feed,
                            arguments: widget.searchOption,
                          );
                        },
                      )
              ],
            ),
          ),
          widget.postList.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                  child: const Center(
                    child: Text(
                      "No Posts Found",
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.postList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PostCardWidget(post: widget.postList[index]);
                  },
                ),
        ],
      ),
    );
  }
}
