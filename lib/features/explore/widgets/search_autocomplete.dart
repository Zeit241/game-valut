import 'package:flutter/material.dart';
import 'package:game_shelf/data/models/game.dart';
import 'package:game_shelf/ui/core/widgets/no_image.dart';
import 'package:game_shelf/utils/api_client.dart';
import 'package:go_router/go_router.dart';

import 'dart:async';

import 'package:lucide_icons_flutter/lucide_icons_200.dart';
import 'package:provider/provider.dart';

import '../../../ui/core/theme/app_colors.dart';
import '../../../ui/core/widgets/shimmer.dart';
import '../../../utils/debounce.dart';
import '../explore_view_model.dart';

class AsyncAutocomplete extends StatefulWidget {
  const AsyncAutocomplete({super.key});

  @override
  State<AsyncAutocomplete> createState() => _AsyncAutocompleteState();
}

class _AsyncAutocompleteState extends State<AsyncAutocomplete> {
  String? _currentQuery;
  String _lastQuery = '';
  bool isLoading = false;
  bool _nothingFound = false;
  String? errorMessage;

  late List<Game> _lastOptions = <Game>[];
  late final Debounceable<List<Game>?, String> _debouncedSearch;

  Future<List<Game>?> _search(String query) async {
    _currentQuery = query;

    List<Game> options = [];
    setState(() {
      isLoading = true;
    });
    final result = await context.read<ExploreViewModel>().search(query);
    if (!mounted) return null;
    setState(() {
      isLoading = false;
    });
    switch (result) {
      case Failure(:final message):
        debugPrint('Search failed: $message');
        setState(() {
          errorMessage = message;
        });
      case Success(:final data):
        setState(() {
          errorMessage = null;
        });
        options = [...data];
    }

    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = debounce<List<Game>, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Game>(
      displayStringForOption: (game) => game.name,
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return ValueListenableBuilder<TextEditingValue>(
              valueListenable: textEditingController,
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
                        onPressed: textEditingController.clear,
                      ),
                    );
                  }
                }

                return TextField(
                  autofocus: false,
                  controller: textEditingController,
                  focusNode: focusNode,
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
            );
          },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        final query = textEditingValue.text;
        if (query.isEmpty) {
          _lastOptions = const [];
          _lastQuery = '';
          _nothingFound = false;
          return const [];
        }
        final List<Game>? options = await _debouncedSearch(query);
        if (options == null) {
          return _lastOptions;
        }
        _lastQuery = query;
        _lastOptions = options;
        _nothingFound = options.isEmpty;
        if (options.isEmpty) {
          return [Game.placeholder()];
        }
        return options;
      },
      onSelected: (Game selection) {
        if (selection.id == -1) return;
      },
      optionsViewBuilder: (context, onSelected, options) {
        final message = errorMessage;
        final showNotice = message != null || _nothingFound;
        final itemCount = showNotice ? 1 : options.length + 1;

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Material(
            color: AppColors.surfaceDefault,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.getColorFormHex('#2A303D'),
                width: 1,
              ),
            ),
            elevation: 8,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (message != null) {
                  return _suggestionText(message);
                }

                if (_nothingFound) {
                  return _suggestionText(
                    'For "$_lastQuery" nothing found. Try to search something else',
                  );
                }

                if (index >= options.length) {
                  return _suggestionText(
                    'Search all games for "$_lastQuery"',
                    color: AppColors.getColorFormHex('#B99AFF'),
                    onTap: () =>
                        GoRouter.of(context)
                            .goNamed('search', extra: {'search': _lastQuery}),
                  );
                }

                final option = options.elementAt(index);
                return _suggestionGame(option, () {
                  GoRouter.of(context).pushNamed(
                    'game-details',
                    pathParameters: {'id': option.id.toString()},
                  );
                  ;
                });
              },
            ),
          ),
        );
      },
    );
  }

  Widget _suggestionText(String text, {Color? color, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color ?? AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _suggestionGame(Game game, VoidCallback onTap) {
    final meta = [
      ?game.parseReleasedYear()?.toString(),
      game.getGameGenres(),
    ].where((s) => s.isNotEmpty).join('  ·  ');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 58,
                  height: 78,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(
                      image: ResizeImage(
                        NetworkImage(
                          game.croppedImage(width: 348, height: 468),
                        ),
                        width: 174,
                      ),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const AppShimmer(
                          child: SizedBox.expand(
                            child: ColoredBox(color: Colors.white),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return NoImage(
                          hasTitle: false,
                          bgColor: AppColors.surfaceElevated,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (meta.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Divider(
            height: 0.5,
            color: AppColors.getColorFormHex('#2A303D'),
          ),
        ),
      ],
    );
  }
}
