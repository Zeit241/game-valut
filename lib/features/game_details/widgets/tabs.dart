import 'package:flutter/material.dart';
import 'package:game_shelf/data/models/detailed_game.dart';
import 'package:game_shelf/data/models/game.dart';
import 'package:game_shelf/features/explore/widgets/game_section.dart';
import 'package:game_shelf/features/game_details/game_details_screen_view_mode.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:game_shelf/utils/api_client.dart';
import 'package:provider/provider.dart';

import '../../../ui/core/widgets/vertical_game_card.dart';

class Tabs extends StatefulWidget {
  final Widget? header;
  final DetailedGame game;

  const Tabs({super.key, this.header, required this.game});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _screensScrollController = ScrollController();

  final _sectionKeys = List.generate(4, (_) => GlobalKey());

  late final TabController _tabController;

  final _tabs = const ['About', 'Platforms', 'Tags', 'Similar Games'];

  int _currentScreenshot = 0;
  int _activeIndex = 0;
  bool _tabUpdateScheduled = false;

  static const _screenshotGap = 12.0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);

    _scrollController.addListener(_onScroll);
    _screensScrollController.addListener(_onScreensScroll);
  }

  double _screenshotWidth(BuildContext context) {
    return (MediaQuery.sizeOf(context).width * 0.85).clamp(275.0, 300.0);
  }

  void _onScreensScroll() {
    if (!mounted || !_screensScrollController.hasClients) return;

    final screenshots = widget.game.screenshots;
    if (screenshots == null || screenshots.isEmpty) return;

    final itemExtent = _screenshotWidth(context) + _screenshotGap;
    final index = (_screensScrollController.offset / itemExtent)
        .round()
        .clamp(0, screenshots.length - 1)
        .toInt();
    if (index == _currentScreenshot) return;

    setState(() => _currentScreenshot = index);
  }

  void _onScroll() {
    if (_tabUpdateScheduled) return;
    _tabUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabUpdateScheduled = false;
      if (!mounted) return;
      _updateActiveTab();
    });
  }

  void _updateActiveTab() {
    final scrollObject = context.findRenderObject();
    if (scrollObject is! RenderBox || !scrollObject.hasSize) return;

    final activationY =
        scrollObject.localToGlobal(Offset.zero).dy + _TabBarDelegate.height + 8;

    var newIndex = 0;

    for (var i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context == null) continue;

      final object = context.findRenderObject();
      if (object is! RenderBox || !object.hasSize) continue;

      final top = object.localToGlobal(Offset.zero).dy;
      final bottom = top + object.size.height;

      if (top <= activationY && bottom > activationY) {
        newIndex = i;
        break;
      }

      if (top <= activationY) {
        newIndex = i;
      }
    }

    if (newIndex != _activeIndex) {
      _activeIndex = newIndex;
      _tabController.animateTo(
        newIndex,
        duration: const Duration(milliseconds: 150),
      );
    }
  }

  Future<void> _scrollToSection(int index) async {
    final context = _sectionKeys[index].currentContext;
    if (context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.15,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _screensScrollController.removeListener(_onScreensScroll);
    _scrollController.dispose();
    _screensScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenshots = widget.game.screenshots;
    final viewModel = context.watch<GameDetailsScreenViewMode>();
    final verticalCardWidth = (MediaQuery.sizeOf(context).width * 0.38).clamp(
      132.0,
      180.0,
    );

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (widget.header != null) SliverToBoxAdapter(child: widget.header),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarDelegate(
            controller: _tabController,
            tabs: _tabs,
            onTap: _scrollToSection,
          ),
        ),

        if (screenshots != null && screenshots.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsGeometry.only(top: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180,
                    child: ListView.builder(

                      controller: _screensScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: screenshots.length,
                      itemBuilder: (context, index) {
                        final imageUrl = screenshots[index]['image'] as String?;
                        if (imageUrl == null) return const SizedBox.shrink();

                        return Container(
                          width: _screenshotWidth(context),
                          margin: const EdgeInsets.only(right: _screenshotGap),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(imageUrl, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '0${_currentScreenshot + 1} / ${screenshots.length < 10 ? 0 : ''}${screenshots.length}  ·  Official game screenshots',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),

        SliverToBoxAdapter(
          child: _buildSection(
            index: 0,
            title: 'About',
            child: Column(
              spacing: 6,
              children: [
                _buildAboutRow(key: 'Release date', value: 'February 25, 2022'),
                _buildAboutRow(
                  key: 'Developer',
                  value: widget.game.developers.first.name,
                ),
                _buildAboutRow(
                  key: 'Publisher',
                  value: widget.game.publisher.first.name,
                ),
                _buildAboutRow(
                  key: 'Playtime',
                  value: '${widget.game.playtime} · Main story',
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: _buildSection(
            index: 1,
            title: 'Platforms',
            child: Wrap(
              spacing: 6,
              runSpacing: 1.0,
              children: [
                ...widget.game.platforms.map(
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
          ),
        ),

        SliverToBoxAdapter(
          child: _buildSection(
            index: 2,
            title: 'Tags',
            child: Text(
              widget.game.tags.map((tag) => tag.name).join('  ·  '),
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: _buildSection(
            index: 3,
            child: FutureBuilder<Result<List<Game>>>(
              future: viewModel.similarGames,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return GameSection(
                    title: 'Similar games',
                    showShimmer: true,
                    cards: List.generate(
                      5,
                      (_) => const VerticalGameCardLoader(),
                    ),
                  );
                }

                return switch (snapshot.data) {
                  Success(:final data) => GameSection(
                    title: 'Similar games',
                    cards: [
                      for (final game in data)
                        SizedBox(
                          width: verticalCardWidth,
                          child: VerticalGameCard(game: game),
                        ),
                    ],
                  ),
                  _ => const Center(child: Text('Не удалось загрузить')),
                };
              },
            ),
          ),
        ),

        //
        const SliverToBoxAdapter(child: SizedBox(height: 48)),
      ],
    );
  }

  Widget _buildAboutRow({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSection({
    required int index,
    String? title,
    required Widget child,
  }) {
    return Container(
      key: _sectionKeys[index],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate({
    required this.controller,
    required this.tabs,
    required this.onTap,
  });

  static const height = 48.0;

  final TabController controller;
  final List<String> tabs;
  final ValueChanged<int> onTap;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: height,
      child: Material(
        color: AppColors.backgroundBase,
        child: TabBar(
          controller: controller,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: AppColors.getColorFormHex('#2A303D'),
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [for (final tab in tabs) Tab(text: tab)],
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller || oldDelegate.tabs != tabs;
  }
}
