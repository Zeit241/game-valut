import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:game_shelf/ui/core/widgets/add_to_library_sheet.dart';
import 'package:game_shelf/ui/core/widgets/game_rating.dart';
import 'package:game_shelf/ui/core/widgets/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../data/models/game.dart';
import '../../../ui/core/widgets/snackbars.dart';

class BigGameCardLoader extends StatelessWidget {
  const BigGameCardLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          height: 322,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class BigGameCard extends StatefulWidget {
  final Game game;

  const BigGameCard({super.key, required this.game});

  @override
  State<BigGameCard> createState() => _BigGameCardState();
}

class _BigGameCardState extends State<BigGameCard> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,

      child: Container(
        height: 322,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: ResizeImage(
                  NetworkImage(widget.game.croppedImage()),
                  width: 1000,
                ),
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Center(
                    child: AppShimmer(
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: SizedBox(
                          height: 322,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(220, 16, 19, 28),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  child: Row(
                    spacing: 6,
                    children: [
                      Icon(
                        LucideIcons.sparkles,
                        size: 13,
                        color: AppColors.getColorFormHex('#B99AFF'),
                      ),
                      Text(
                        'The spotlight'.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x1207090D),
                      Color(0x2107090D),
                      Color(0xF507090D),
                    ],
                    stops: [0, 0.35, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.game.name,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        [
                          ?widget.game.parseReleasedYear()?.toString(),
                          widget.game.getGameGenres(limit: 3),
                        ].where((s) => s.isNotEmpty).join('  ·  '),
                        style: TextStyle(
                          color: AppColors.getColorFormHex('#D2D4D9'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GameRating(rating: widget.game.rating),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            GoRouter.of(context).pushNamed(
                              'game-details',
                              pathParameters: {'id': widget.game.id.toString()},
                            );
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.arrowUpRight),
                              SizedBox(width: 8),
                              Text('View game'),
                            ],
                          ),
                        ),
                      ),
                      IconButton.outlined(
                        onPressed: () {
                          AddToLibrarySheet.show(context, widget.game);
                        },
                        icon: const Icon(LucideIcons.bookmark, size: 22),
                        style: IconButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          backgroundColor: AppColors.surfaceDefault,
                          side: const BorderSide(color: Color(0xFF2A303D)),
                          fixedSize: const Size(44, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
