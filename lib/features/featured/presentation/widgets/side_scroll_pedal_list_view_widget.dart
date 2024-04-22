import 'package:flutter/material.dart';
import 'package:pedalpulse/core/common/providers/app_size_provider.dart';
import 'package:pedalpulse/widgets/loading_placeholder_widget.dart';

import '../../../../injection_container.dart';
import '../../../pedals/domain/entities/pedal_entity.dart';
import '../../../pedals/presentation/widgets/pedal_card_widget.dart';

class SideScrollPedalListViewWidget extends StatelessWidget {
  final String title;
  final List<PedalEntity> pedals;
  final bool isLoading;
  const SideScrollPedalListViewWidget({
    Key? key,
    required this.pedals,
    required this.title,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = getIt<AppSizeProvider>().size;
    final double cardWidth = size.width / 2 - 16;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: isLoading
          ? const LoadingPlaceholderWidget()
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    return true;
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: cardWidth + 124,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: pedals.length,
                          itemBuilder: (context, index) {
                            return PedalCardWidget(
                              pedal: pedals[index],
                              isSelectable: false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
