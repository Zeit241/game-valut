import 'package:flutter/material.dart';
import 'package:game_shelf/features/search/search_screen_view_mode.dart';
import 'package:game_shelf/features/search/widgets/no_found.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lucide_icons_flutter/lucide_icons_200.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/game_repository.dart';
import '../../data/services/games_api_service.dart';
import '../../ui/core/theme/app_colors.dart';
import '../../ui/core/widgets/cards_grid.dart';
import '../../ui/core/widgets/segmented_tabs.dart';
import '../../ui/core/widgets/shimmer.dart';
import '../../ui/core/widgets/vertical_game_card.dart';
import '../../utils/api_client.dart';
import '../../utils/debounce.dart';
import 'constants.dart';

class SearchScreen extends StatelessWidget {
  final String? search;

  const SearchScreen({super.key, this.search});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(GameRepository(GamesApiService()))
        ..load(search: search)
        ..loadGenres(),

      child: const SearchScreenContent(),
    );
  }
}

class SearchScreenContent extends StatefulWidget {
  const SearchScreenContent({super.key});

  @override
  State<SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<SearchScreenContent> {
  late ScrollController controller;
  late final TextEditingController _textEditingController =
      TextEditingController(text: context.read<SearchViewModel>().search ?? '');
  bool isSettingsOpen = false;
  bool isLoading = false;
  int ordering = 1;
  Map<String, List<int>> filter = {'platforms': [], 'genres': []};

  int getFiltersCount() {
    return filter.values.fold<int>(0, (sum, value) {
      return sum + value.length;
    });
  }

  late final Debounceable<void, String> _debouncedSearch;

  Future<void> _search(String query) async {
    setState(() {
      isLoading = true;
    });

    await context.read<SearchViewModel>().load(
      search: query,
      filters: filter,
      ordering: convertOrderingTo(),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _debouncedSearch = debounce<void, String>(_search);
    controller = ScrollController()..addListener(_scrollListener);

    _textEditingController.addListener(() async {
      final String text = _textEditingController.text;

      await _debouncedSearch(text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      context.read<SearchViewModel>().loadMore();
    }
  }

  String convertOrderingTo() {
    return orderingOptions.keys.elementAt(ordering);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchViewModel>();
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Text(
            'Find your next world',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _textEditingController,
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
                            onPressed: _textEditingController.clear,
                          ),
                        );
                      }
                    }

                    return SizedBox(
                      height: 48,
                      child: TextField(
                        autofocus: false,
                        onTap: () {
                          setState(() {
                            isSettingsOpen = false;
                          });
                        },
                        controller: _textEditingController,
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
                      ),
                    );
                  },
                ),
              ),

              Badge.count(
                count: getFiltersCount(),
                isLabelVisible: !isSettingsOpen && getFiltersCount() > 0,
                backgroundColor: AppColors.accent,
                textColor: AppColors.textPrimary,
                child: IconButton.outlined(
                  style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    backgroundColor: isSettingsOpen
                        ? AppColors.getColorFormHex('#251C3D')
                        : AppColors.surfaceDefault,
                    foregroundColor: isSettingsOpen
                        ? AppColors.getColorFormHex('#6C48AA')
                        : AppColors.textPrimary,
                    side: BorderSide(
                      color: isSettingsOpen
                          ? AppColors.getColorFormHex('#6C48AA')
                          : AppColors.getColorFormHex('#2A303D'),
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      isSettingsOpen = !isSettingsOpen;
                    });
                  },
                  icon: const Icon(LucideIcons.listFilter),
                ),
              ),
            ],
          ),
          if (isSettingsOpen)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDefault,
                borderRadius: BorderRadius.circular(16),
                border: BoxBorder.all(
                  color: AppColors.getColorFormHex('#2A303D'),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            filter = {'platforms': [], 'genres': []};
                            ordering = 0;
                          });
                        },
                        child: Text('Reset all'),
                      ),
                    ],
                  ),
                  _buildFilterRow("Platforms", 'platforms', platformsOptions),
                  const SizedBox(height: 16),
                  switch (viewModel.genres) {
                    null => const SizedBox(
                      height: 45,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    Success(:final data) => _buildFilterRow('Genre', 'genres', {
                      for (final genre in data) genre.id: genre.name,
                    }),
                    Failure(:final message) => Text(message),
                  },
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedTabs(
                      selected: ordering,
                      labels: [...orderingOptions.values.map((e) => Text(e))],
                      onChanged: (int selected) {
                        setState(() {
                          ordering = selected;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () async {
                        setState(() {
                          isSettingsOpen = false;
                        });
                        if (isLoading) {
                          return;
                        }
                        await _search(_textEditingController.text);
                      },
                      child: isLoading
                          ? SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.textPrimary,
                              ),
                            )
                          : Text('Search'),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: switch (viewModel.games) {
              null => CardsGrid(
                controller: controller,
                itemCount: (_) => 10,
                itemBuilder: (_) =>
                    const AppShimmer(child: VerticalGameCardLoader()),
              ),
              _ when isLoading => CardsGrid(
                controller: controller,
                itemCount: (_) => 10,
                itemBuilder: (_) =>
                    const AppShimmer(child: VerticalGameCardLoader()),
              ),
              Failure(:final message) => Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(message),
              ),
              Success(count: 0) => NoFound(
                search: _textEditingController.text,
                reset: () {
                  setState(() {
                    filter = {'platforms': [], 'genres': []};
                    ordering = 0;
                  });
                  _search(_textEditingController.text);
                },
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

  Widget _buildFilterRow(
    String title,
    String filterName,
    Map<int, String> options,
  ) {
    return Column(
      spacing: 9,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final option = options.entries.elementAt(index);
              final bool isOptionAlreadySelected =
                  filter[filterName]?.contains(option.key) ?? false;

              return InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    if (!isOptionAlreadySelected) {
                      filter = {
                        ...filter,
                        filterName: [option.key, ...?filter[filterName]],
                      };
                    } else {
                      final newValue = filter[filterName]?..remove(option.key);
                      filter = {
                        ...filter,
                        filterName: [...?newValue],
                      };
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isOptionAlreadySelected
                        ? AppColors.getColorFormHex('#251C3D')
                        : AppColors.surfaceDefault,
                    borderRadius: BorderRadius.circular(100),
                    border: BoxBorder.all(
                      color: isOptionAlreadySelected
                          ? AppColors.getColorFormHex('#6C48AA')
                          : AppColors.getColorFormHex('#2A303D'),
                    ),
                  ),
                  height: 50,
                  child: Center(child: Text(option.value)),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 8);
            },
          ),
        ),
      ],
    );
  }
}
