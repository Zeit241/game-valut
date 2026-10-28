import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:game_shelf/ui/core/widgets/shimmer.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/game.dart';
import '../../../ui/core/widgets/game_rating.dart';

class HorizontalGameCard extends StatelessWidget {
  static const titleBlockHeight = 13 * 1.2 * 2;
  static const metaBlockHeight = 11 * 1.2;
  static const blockSpacing = 6.0;

  final Game game;

  const HorizontalGameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final poster = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image(
        image: ResizeImage(NetworkImage(game.croppedImage()), width: 400),
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const AppShimmer(
            child: SizedBox.expand(child: ColoredBox(color: Colors.white)),
          );
        },
      ),
    );

    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () {
        GoRouter.of(
          context,
        ).pushNamed('game-details', pathParameters: {'id': game.id.toString()});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surfaceDefault,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 62, height: 82, child: poster),
              Expanded(
                child: Column(
                  spacing: blockSpacing,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      game.parseReleasedYear()!.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GameRating(rating: game.rating),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalGameCardLoader extends StatelessWidget {
  const HorizontalGameCardLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: HorizontalGameCard.blockSpacing,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 62,
          height: 82,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        Column(
          spacing: HorizontalGameCard.blockSpacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: HorizontalGameCard.titleBlockHeight,
              width: 140,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
            SizedBox(
              height: HorizontalGameCard.metaBlockHeight,
              width: 90,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
