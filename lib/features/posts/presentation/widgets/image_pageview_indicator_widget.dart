import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/managers/color_manager.dart';
import '../../../../core/common/widgets/custom_circle_icon_button_widget.dart';
import '../../../../core/common/widgets/loading_placeholder_widget.dart';

class ImagePageviewIndicatorWidget extends StatefulWidget {
  final List<String> imageUrls;
  const ImagePageviewIndicatorWidget({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  _ImagePageviewIndicatorWidgetState createState() =>
      _ImagePageviewIndicatorWidgetState();
}

class _ImagePageviewIndicatorWidgetState
    extends State<ImagePageviewIndicatorWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;

    return Stack(
      children: [
        SizedBox(
          width: width,
          height: width,
          child: Stack(
            children: [
              PageView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    color: ColorManager.primaryColorLight,
                    width: width,
                    height: width,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrls[index],
                      placeholder: (context, url) => const Center(
                        child: LoadingPlaceholderWidget(),
                      ),
                      fit: BoxFit.contain,
                    ),
                  );
                },
                itemCount: widget.imageUrls.length,
                controller: _pageController,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: widget.imageUrls.length > 1
                    ? _buildIndicator()
                    : Container(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: [
              CustomCircleIconButtonWidget(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(
                  context,
                ),
              ),
              const Spacer(),
              // CustomCircleIconButtonWidget(
              //   icon: const Icon(
              //     Icons.ios_share,
              //     color: Colors.white,
              //   ),
              //   onPressed: () {},
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.imageUrls.length, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? ColorManager.appPrimaryColor
                : Colors.grey,
          ),
        );
      }),
    );
  }
}
