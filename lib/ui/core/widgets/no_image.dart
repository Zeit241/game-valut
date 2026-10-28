import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoImage extends StatelessWidget {
  final bool hasTitle;
  final double iconSize;
  final Color bgColor;

  const NoImage({
    super.key,
    this.hasTitle = true,
    this.iconSize = 28,
    this.bgColor = AppColors.surfaceDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.imageOff,
              size: iconSize,
              color: AppColors.getColorFormHex('#9CA3AF'),
            ),
            if (hasTitle)
              Text(
                'No artwork',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
          ],
        ),

    );
  }
}
