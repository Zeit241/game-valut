import 'package:flutter/material.dart';
import 'package:game_shelf/features/game_details/widgets/tabs.dart';
import 'package:game_shelf/ui/core/widgets/game_rating.dart';
import 'package:game_shelf/utils/api_client.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lucide_icons_flutter/lucide_icons_200.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/game_repository.dart';
import '../../data/services/games_api_service.dart';
import '../../ui/core/theme/app_colors.dart';
import '../../ui/core/widgets/add_to_library_sheet.dart';
import 'game_details_screen_view_mode.dart';

class GameDetailsScreen extends StatelessWidget {
  final int id;

  const GameDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          GameDetailsScreenViewMode(GameRepository(GamesApiService()))
            ..load(id),
      child: const GameDetailsScreenContent(),
    );
  }
}

class GameDetailsScreenContent extends StatefulWidget {
  const GameDetailsScreenContent({super.key});

  @override
  State<GameDetailsScreenContent> createState() =>
      _GameDetailsScreenContentState();
}

class _GameDetailsScreenContentState extends State<GameDetailsScreenContent> {
  bool isFullTextVisible = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameDetailsScreenViewMode>();
    return switch (viewModel.game) {
      null => Text(''),
      Success(:final data) => Tabs(
        game: data,
        header: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(data.backgroundImage, fit: BoxFit.cover),
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
                    top: 8,
                    left: 20,
                    child: IconButton.outlined(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      icon: Icon(LucideIcons200.arrowLeft),
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
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(left: 20, right: 20, top: 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 96,
                          height: 132,
                          child: AspectRatio(
                            aspectRatio: 92 / 135,
                            child: Image.network(
                              data.backgroundImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 6,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${data.parseReleasedYear() ?? ''}  ·  ${data.developers.firstOrNull?.name ?? ''}',
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                GameRating(rating: data.rating),
                                Text('${data.ratingsCount} ratings'),
                              ],
                            ),
                            Row(
                              spacing: 6,
                              children: [
                                if (data.parentPlatforms.any(
                                  (platform) => platform.name == 'PC',
                                ))
                                  Icon(LucideIcons.monitor),
                                if (data.parentPlatforms.any(
                                  (platform) =>
                                      platform.name == 'PlayStation' ||
                                      platform.name == 'Xbox',
                                ))
                                  Icon(LucideIcons.gamepad2),
                                Text(
                                  data.getShortGameParentPlatforms(limit: 3),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Wrap(
                    spacing: 6,
                    runSpacing: 1.0,
                    children: [
                      ...data.genres.map(
                        (e) => Chip(
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          backgroundColor: AppColors.surfaceDefault,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          side: BorderSide(
                            color: AppColors.getColorFormHex('#2A303D'),
                            width: 1,
                          ),
                          label: Text(e.name),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: data.description,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        maxLines: isFullTextVisible ? null : 3,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isFullTextVisible = !isFullTextVisible;
                          });
                        },
                        child: Text(
                          !isFullTextVisible ? 'Read more' : 'Show less',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      label: Text('Add to library'),
                      icon: Icon(LucideIcons.plus),
                      style: ButtonStyle(),
                      onPressed: () {
                        AddToLibrarySheet.show(context, data);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Failure(:final message) => Text(message),
    };
  }
}
