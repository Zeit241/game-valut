import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game_shelf/data/repositories/game_repository.dart';
import 'package:game_shelf/data/repositories/library_repository.dart';
import 'package:game_shelf/data/services/games_api_service.dart';
import 'package:game_shelf/features/library/library_screen_view_mode.dart';
import 'package:game_shelf/features/search/widgets/no_found.dart';
import 'package:game_shelf/ui/core/database/app_database.dart';
import 'package:game_shelf/ui/core/database/tables/library_games.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lucide_icons_flutter/lucide_icons_200.dart';
import 'package:provider/provider.dart';

import '../../ui/core/widgets/add_to_library_sheet.dart';
import '../../utils/debounce.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LibraryScreenViewMode(
        LibraryRepository(AppDatabase()),
        GameRepository(GamesApiService()),
      )..getGames(),
      child: LibraryScreenContent(),
    );
  }
}

class LibraryScreenContent extends StatefulWidget {
  const LibraryScreenContent({super.key});

  @override
  State<LibraryScreenContent> createState() => _LibraryScreenContentState();
}

class _LibraryScreenContentState extends State<LibraryScreenContent> {
  late final Debounceable<void, String> _debouncedSearch;
  final TextEditingController _controller = TextEditingController();
  String _lastQuery = '';
  bool isLoading = false;
  int? _loadingGameId;

  Future<void> _search(String query) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    await context.read<LibraryScreenViewMode>().getGames(search: query);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  void _onQueryChanged() {
    final text = _controller.text;
    if (text == _lastQuery) return;
    _lastQuery = text;
    _debouncedSearch(text);
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = debounce<void, String>(_search);
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onEdit() {
    context.read<LibraryScreenViewMode>().getGames(search: _controller.text);
  }

  Future<void> onSettingTap(int id) async {
    final apiGame = await context.read<LibraryScreenViewMode>().getGameFromApi(
      id,
    );
    if (!mounted || apiGame == null) return;

    AddToLibrarySheet.show(context, apiGame, callback: onEdit);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LibraryScreenViewMode>();
    final games = viewModel.games;
    final toPlay = (games ?? []).where((game) => game.status == Status.backlog);
    final playing = (games ?? []).where(
      (game) => game.status == Status.playing,
    );
    final finished = (games ?? []).where(
      (game) => game.status == Status.completed,
    );
    final dropped = (games ?? []).where(
      (game) => game.status == Status.dropped,
    );

    return Padding(
      padding: .only(top: 12, left: 20, right: 20),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'My Library',
                    style: .new(fontSize: 28, fontWeight: .bold),
                  ),
                  Text(
                    '${games?.length} games in your collection',
                    style: .new(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 48,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, child) {
                Widget? suffixIcon;
                if (value.text.isNotEmpty) {
                  if (isLoading) {
                    suffixIcon = const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  } else {
                    suffixIcon = Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        icon: Icon(
                          LucideIcons200.x,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: _controller.clear,
                      ),
                    );
                  }
                }

                return TextField(
                  autofocus: false,
                  controller: _controller,
                  style: TextStyle(color: AppColors.textSecondary),
                  decoration: InputDecoration(
                    suffixIcon: suffixIcon,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: const Icon(LucideIcons200.search),
                    ),
                    prefixIconColor: AppColors.textSecondary,
                    hintText: 'Search games, genres, platforms...',
                  ),
                  textInputAction: TextInputAction.search,
                );
              },
            ),
          ),
          if (games?.isEmpty ?? true)
            NoFound(search: _lastQuery, reset: _controller.clear),
          if (games != null) ...[
            Row(children: [Text('All games · ${games.length}')]),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  final isCompact = MediaQuery.sizeOf(context).width < 360;
                  //
                  final coverWidth = isCompact ? 80.0 : 96.0;
                  final coverHeight = coverWidth * (135 / 92);
                  final game = games[index];
                  return Row(
                    spacing: 16,
                    children: [
                      SizedBox(
                        height: coverHeight,
                        width: coverWidth,
                        child: ClipRRect(
                          borderRadius: .circular(12),
                          child: Image.memory(
                            game.backgroundImage!,
                            fit: .cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          spacing: 10,
                          children: [
                            Text(
                              game.name,
                              style: .new(fontSize: 16, fontWeight: .w600),
                            ),
                            Row(
                              spacing: 10,
                              children: [StatusPill(status: game.status)],
                            ),
                            if (game.status == Status.completed)
                              _finishedGame(game),
                            if (game.status == Status.playing)
                              _playingGame(game),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(10, 0),
                        child: IconButton(
                          onPressed: () async {
                            if (_loadingGameId != null) return;
                            setState(() => _loadingGameId = game.id);
                            await onSettingTap(game.id);
                            if (!mounted) return;
                            setState(() => _loadingGameId = null);
                          },
                          icon: _loadingGameId == game.id
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(LucideIcons.ellipsisVertical),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 16);
                },
                itemCount: games.length,
              ),
            ),
            Padding(
              padding: .only(bottom: 10, top: 5),
              child: Row(
                spacing: 10,
                mainAxisAlignment: .center,
                children: [
                  Text(
                    '${toPlay.length} to play',
                    style: .new(color: AppColors.getColorFormHex('#B99AFF')),
                  ),
                  Text(
                    '${playing.length} playing',
                    style: .new(color: AppColors.statusPlaying),
                  ),
                  Text(
                    '${finished.length} finished',
                    style: .new(color: AppColors.statusCompleted),
                  ),
                  Text(
                    '${dropped.length} dropped',
                    style: .new(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _finishedGame(LibraryGame game) {
    return Row(
      children: [
        Text(
          List.filled(game.rating, '★').join(),
          style: .new(color: AppColors.getColorFormHex('#B99AFF')),
        ),
        Text(
          List.filled(5 - game.rating, '★').join(),
          style: .new(color: AppColors.textSecondary),
        ),
        if (game.endedAt != null)
          Text(' · ${DateFormat('MMM dd').format(game.endedAt!)}'),
      ],
    );
  }

  Widget _playingGame(LibraryGame game) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: game.completion.toDouble() / 100,
            backgroundColor: AppColors.surfaceElevated,
            color: AppColors.statusPlaying,
          ),
        ),
        Text(
          '${game.completion}%',
          style: .new(color: AppColors.statusPlaying),
        ),
      ],
    );
  }
}
