import 'package:flutter/material.dart';
import 'package:game_shelf/features/explore/game_list_view_model.dart';
import 'package:game_shelf/routing/router.dart';
import 'package:game_shelf/ui/core/widgets/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/game_repository.dart';
import '../../data/services/games_api_service.dart';
import '../../ui/core/theme/app_colors.dart';
import '../../ui/core/widgets/cards_grid.dart';
import '../../ui/core/widgets/vertical_game_card.dart';
import '../../utils/api_client.dart';

const Map<GameListKind, String> kindTitleMap = {
  GameListKind.popular: 'Popular This Week',
  GameListKind.recentlyReleased: 'Recently Released',
  GameListKind.trending: 'Trending Now',
};

class GameListScreen extends StatelessWidget {
  final GameListKind kind;

  const GameListScreen({super.key, required this.kind});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          GameListViewModel(GameRepository(GamesApiService()), kind)..load(),

      child: GameListScreenContent(kind: kind),
    );
  }
}

class GameListScreenContent extends StatefulWidget {
  final GameListKind kind;

  const GameListScreenContent({super.key, required this.kind});

  @override
  State<GameListScreenContent> createState() => _GameListScreenContentState();
}

class _GameListScreenContentState extends State<GameListScreenContent> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      context.read<GameListViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameListViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        children: [
          Row(
            spacing: 14,
            children: [
              IconButton.outlined(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(LucideIcons.chevronLeft, size: 20),
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
              Text(
                kindTitleMap[widget.kind]!,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: switch (viewModel.games) {
              null => CardsGrid(
                controller: controller,
                itemCount: (_) => 10,
                itemBuilder: (_) =>
                    const AppShimmer(child: VerticalGameCardLoader()),
              ),
              Failure(:final message) => Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(message),
              ),
              Success(:final data) => CardsGrid(
                controller: controller,
                itemCount: (columns) =>
                    data.length + (viewModel.isLoadingMore ? columns : 0),
                itemBuilder: (index) {
                  if (index >= data.length) {
                    return const AppShimmer(child: VerticalGameCardLoader());
                  }
                  return VerticalGameCard(game: data[index]);
                },
              ),
            },
          ),
        ],
      ),
    );
  }
}
