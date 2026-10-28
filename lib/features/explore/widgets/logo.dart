import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons_weights.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        spacing: 9,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.getColorFormHex("#251C3D"),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Icon(
              LucideIcons300.gamepad2,
              color: AppColors.getColorFormHex("#B99AFF"),
            ),
          ),
          Text(
            "GameVault",
            style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
