import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GameRating extends StatelessWidget {
  final double rating;

  const GameRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.getColorFormHex('#143028'),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        child: Text(
          '★ $rating',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.statusCompleted,
          ),
        ),
      ),
    );
  }
}
