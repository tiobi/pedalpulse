import 'package:flutter/material.dart';
import 'package:pedalpulse/widgets/custom_circle_icon_button_widget.dart';
import 'package:pedalpulse/widgets/pedal_card_widget.dart';

import '../models/pedal_model.dart';

class SidescrollPedalListviewWidget extends StatefulWidget {
  final String title;
  final List<PedalModel> pedalList;

  const SidescrollPedalListviewWidget({
    Key? key,
    required this.title,
    required this.pedalList,
  }) : super(key: key);

  @override
  State<SidescrollPedalListviewWidget> createState() =>
      _SidescrollPedalListviewWidgetState();
}

class _SidescrollPedalListviewWidgetState
    extends State<SidescrollPedalListviewWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start scrolling when the widget is first created.
  }

  void _updateIconTransparency(ScrollNotification scrollNotification) {
    setState(() {
      double opacity = _calculateOpacity();
      if (opacity >= 0.0 && opacity <= 1.0) {
        _iconOpacity = opacity;
      }
    });
  }

  double _iconOpacity = 1.0;

  double _calculateOpacity() {
    const double threshold = 100.0;
    double offset =
        _scrollController.hasClients ? _scrollController.offset : 0.0;
    double opacity = (threshold - offset) / threshold;
    return opacity.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double cardWidth = size.width / 2 - 16;
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _updateIconTransparency(notification);
              return true;
            },
            child: Stack(
              children: [
                SizedBox(
                  height: cardWidth + 124,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.pedalList.length,
                    itemBuilder: (context, index) {
                      return PedalCardWidget(
                        pedal: widget.pedalList[index],
                        isSelectable: false,
                      );
                    },
                  ),
                ),
                widget.pedalList.length > 3
                    ? Positioned(
                        height: cardWidth + 100,
                        right: 10,
                        child: Opacity(
                          opacity: _iconOpacity,
                          child: const Center(
                            child: CustomCircleIconButtonWidget(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
