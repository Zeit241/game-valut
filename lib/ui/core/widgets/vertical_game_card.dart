import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:game_shelf/ui/core/widgets/no_image.dart';
import 'package:game_shelf/ui/core/widgets/shimmer.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/game.dart';
import 'game_rating.dart';

class VerticalGameCard extends StatelessWidget {
  static const posterAspectRatio = 132 / 178;
  static const titleBlockHeight = 13 * 1.2 * 2;
  static const metaBlockHeight = 11 * 1.2;
  static const blockSpacing = 6.0;

  final Game game;

  const VerticalGameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final poster = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image(
                image: ResizeImage(
                  NetworkImage(game.croppedImage()),
                  width: 400,
                ),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return AppShimmer(
                    child: SizedBox.expand(
                      child: ColoredBox(color: Colors.white),
                    ),
                  );
                },
                errorBuilder: (context, child, loadingProgress) {
                  return NoImage();
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GameRating(rating: game.rating),
              ),
            ],
          ),
        );

        return InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () {
            GoRouter.of(context).pushNamed(
              'game-details',
              pathParameters: {'id': game.id.toString()},
            );
          },
          child: Column(
            spacing: blockSpacing,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (constraints.hasBoundedHeight)
                Expanded(child: poster)
              else
                AspectRatio(aspectRatio: posterAspectRatio, child: poster),
              SizedBox(
                height: titleBlockHeight,
                child: Text(
                  game.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: metaBlockHeight,
                child: Text(
                  [
                    ?game.parseReleasedYear()?.toString(),
                    game.getGameGenres(),
                  ].where((s) => s.isNotEmpty).join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VerticalGameCardLoader extends StatelessWidget {
  const VerticalGameCardLoader({super.key});

  @override
  Widget build(BuildContext context) {
    const poster = SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          spacing: VerticalGameCard.blockSpacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (constraints.hasBoundedHeight)
              const Expanded(child: poster)
            else
              const SizedBox(
                width: 132,
                child: AspectRatio(
                  aspectRatio: VerticalGameCard.posterAspectRatio,
                  child: poster,
                ),
              ),
            const SizedBox(
              height: VerticalGameCard.titleBlockHeight,
              width: 110,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
            const SizedBox(
              height: VerticalGameCard.metaBlockHeight,
              width: 80,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
