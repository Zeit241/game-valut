import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/widgets/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GameSection extends StatefulWidget {
  final String title;
  final String? url;
  final List<Widget> cards;
  final bool showShimmer;

  const GameSection({
    super.key,
    required this.title,
    this.url,
    required this.cards,
    this.showShimmer = false,
  });

  @override
  State<GameSection> createState() => _GameSectionState();
}

class _GameSectionState extends State<GameSection> {
  @override
  Widget build(BuildContext context) {
    final row = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.cards,
      ),
    );

    final url = widget.url;

    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: TextStyle(fontSize: 19)),
            if (url != null)
              TextButton(
                onPressed: () {
                  GoRouter.of(context)
                      .pushNamed('game-list', pathParameters: {'kind': url});
                },
                child: Row(
                  children: [
                    Text('See all'),
                    Icon(LucideIcons.arrowUpRight, size: 12),
                  ],
                ),
              ),
          ],
        ),
        widget.showShimmer ? AppShimmer(child: row) : row,
      ],
    );
  }
}
