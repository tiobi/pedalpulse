import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/routes.dart';
import '../../../../core/common/managers/color_manager.dart';
import '../../../../core/common/widgets/loading_placeholder_widget.dart';
import '../../domain/entities/pedal_entity.dart';

class PedalCardWidget extends StatefulWidget {
  final PedalEntity pedal;
  final bool isSelectable;
  final bool isSelected;
  const PedalCardWidget({
    super.key,
    required this.pedal,
    this.isSelectable = false,
    this.isSelected = false,
  });

  @override
  State<PedalCardWidget> createState() => _PedalCardWidgetState();
}

class _PedalCardWidgetState extends State<PedalCardWidget> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double cardWidth = size.width / 2 - 16;

    return GestureDetector(
      onTap: () {
        widget.isSelectable
            ? setState(() {
                // _selected
                //     ? Provider.of<PedalProvider>(context, listen: false)
                //         .removePedal(widget.pedal)
                //     : Provider.of<PedalProvider>(context, listen: false)
                //         .addPedal(widget.pedal);
                _selected = !_selected;
              })
            : Navigator.of(context).pushNamed(
                Routes.pedalDetails,
                arguments: widget.pedal,
              );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(4),
        width: cardWidth,
        height: cardWidth * 1.5,
        decoration: BoxDecoration(
          color: ColorManager.backgroundColorLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ColorManager.backgroundColorLight,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: Container(
                      height: cardWidth - 10,
                      width: cardWidth - 10,
                      color: ColorManager.primaryColorLight,
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.pedal.imageUrls[0],
                        placeholder: (context, url) => const Center(
                          child: LoadingPlaceholderWidget(),
                        ),
                      ),
                    ),
                  ),
                ),
                widget.isSelectable
                    ? _selected
                        ? Container(
                            height: cardWidth - 10,
                            width: cardWidth - 10,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: ColorManager.appSecondaryColor,
                              size: 40,
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.pedal.brand,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.pedal.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.pedal.category[0],
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
