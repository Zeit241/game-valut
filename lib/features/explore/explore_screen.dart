import 'package:flutter/material.dart';
import 'package:game_shelf/data/services/games_api_service.dart';
import 'package:game_shelf/features/explore/widgets/big_game_card.dart';
import 'package:game_shelf/features/explore/widgets/game_section.dart';
import 'package:game_shelf/features/explore/widgets/horizontal_game_card.dart';
import 'package:game_shelf/features/explore/widgets/logo.dart';
import 'package:game_shelf/features/explore/widgets/profile_avatar.dart';
import 'package:game_shelf/features/explore/widgets/search_autocomplete.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:game_shelf/ui/core/widgets/vertical_game_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/game_repository.dart';
import '../../utils/api_client.dart';
import 'explore_view_model.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ExploreViewModel(GameRepository(GamesApiService()))..loadGames(),

      child: const ExploreScreenContent(),
    );
  }
}

class ExploreScreenContent extends StatefulWidget {
  const ExploreScreenContent({super.key});

  @override
  State<ExploreScreenContent> createState() => _ExploreScreenContentState();
}

class _ExploreScreenContentState extends State<ExploreScreenContent> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExploreViewModel>();
    final verticalCardWidth = (MediaQuery.sizeOf(context).width * 0.38).clamp(
      132.0,
      180.0,
    );

    final horizontalCardWidth = (MediaQuery.sizeOf(context).width * 0.85).clamp(
      275.0,
      300.0,
    );

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: AppColors.backgroundBase),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: SizedBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Logo(), ProfileAvatar()],
                ),
                SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Discover your \nnext adventure',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.15,
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 18),
                AsyncAutocomplete(),
                SizedBox(height: 28),
                switch (viewModel.spotlightGame) {
                  null => BigGameCardLoader(),
                  Failure(:final message) => Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(message),
                  ),
                  Success(:final data) => BigGameCard(game: data),
                },
                SizedBox(height: 28),
                switch (viewModel.trendingNowGames) {
                  null => GameSection(
                    title: 'Trending Now',
                    url: 'trending',
                    showShimmer: true,
                    cards: List.generate(
                      5,
                      (_) => const VerticalGameCardLoader(),
                    ),
                  ),
                  Failure(:final message) => Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(message),
                  ),
                  Success(:final data) => GameSection(
                    title: 'Trending Now',
                    url: 'trending',
                    cards: [
                      for (final game in data)
                        SizedBox(
                          width: verticalCardWidth,
                          child: VerticalGameCard(game: game),
                        ),
                    ],
                  ),
                },
                SizedBox(height: 28),
                switch (viewModel.popularThisWeekGames) {
                  null => GameSection(
                    title: 'Popular This Week',
                    url: 'popular',
                    showShimmer: true,
                    cards: List.generate(
                      5,
                      (_) => const HorizontalGameCardLoader(),
                    ),
                  ),
                  Failure(:final message) => Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(message),
                  ),
                  Success(:final data) => GameSection(
                    title: 'Popular This Week',
                    url: 'popular',
                    cards: [
                      for (final game in data)
                        SizedBox(
                          width: horizontalCardWidth,
                          child: HorizontalGameCard(game: game),
                        ),
                    ],
                  ),
                },
                SizedBox(height: 28),
                switch (viewModel.recentlyReleasedGames) {
                  null => GameSection(
                    title: 'Recently Released',
                    url: 'recentlyReleased',
                    showShimmer: true,
                    cards: List.generate(
                      5,
                      (_) => const VerticalGameCardLoader(),
                    ),
                  ),
                  Failure(:final message) => Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(message),
                  ),
                  Success(:final data) when data.isEmpty => const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text('Пока нет новых релизов.'),
                  ),
                  Success(:final data) => GameSection(
                    title: 'Recently Released',
                    url: 'recentlyReleased',
                    cards: [
                      for (final game in data)
                        SizedBox(
                          width: verticalCardWidth,
                          child: VerticalGameCard(game: game),
                        ),
                    ],
                  ),
                },
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 7,
                  children: [
                    Icon(
                      LucideIcons.sparkles,
                      size: 13,
                      color: AppColors.getColorFormHex('#667085'),
                    ),
                    Text(
                      'Great games. Worth your time.',
                      style: TextStyle(
                        color: AppColors.getColorFormHex('#667085'),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
