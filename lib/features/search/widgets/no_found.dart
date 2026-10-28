import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lucide_icons_flutter/lucide_icons_200.dart';

class NoFound extends StatelessWidget {
  final String search;
  final Function() reset;

  const NoFound({super.key, required this.search, required this.reset});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsetsGeometry.only(top: 36), child: Column(
      spacing: 15,
      children: [
        Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.getColorFormHex('#251C3D'),
            borderRadius: BorderRadius.circular(24)
          ),

          child: Icon(
            LucideIcons200.sparkles,
            color: AppColors.getColorFormHex('#B99AFF'),
            size: 30,
          ),
        ),
        Text('No worlds found', style: TextStyle(fontSize: 22),),
        Text(
          textAlign: TextAlign.center,
          search.trim().isEmpty
              ? 'No games match these filters. Try a different title or clear your filters.'
              : 'No games match “$search”. Try a different title or clear your filters.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        FilledButton.icon(
          onPressed: reset,
          icon: const Icon(LucideIcons.compass, size: 18),
          label: const Text('Clear filters'),
        ),
      ],
    ));
  }
}
