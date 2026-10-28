import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/widgets/vertical_game_card.dart';

class CardsGrid extends StatelessWidget {
  final int Function(int columns) itemCount;
  final Widget Function(int index) itemBuilder;
  final ScrollController controller;

  const CardsGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 700 ? 4 : 2;
    final cellWidth = (width - 40 - 12 * (columns - 1)) / columns;
    final cellHeight =
        cellWidth / VerticalGameCard.posterAspectRatio +
        VerticalGameCard.titleBlockHeight +
        VerticalGameCard.metaBlockHeight +
        VerticalGameCard.blockSpacing * 2;

    return GridView.builder(
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: cellHeight,
      ),
      padding: EdgeInsets.only(bottom: 28),
      itemCount: itemCount(columns),
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}
