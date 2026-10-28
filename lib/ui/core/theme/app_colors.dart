import 'package:flutter/material.dart';

abstract final class AppColors {
  static Color getColorFormHex(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  static const Color backgroundRaised = Color(0xFF11141B);
  static const Color backgroundBase = Color(0xFF0B0D12);

  static const Color surfaceElevated = Color(0xFF202532);
  static const Color surfaceDefault = Color(0xFF181C26);

  static const Color accent = Color(0xFF8B5CF6);

  static const Color statusCompleted = Color(0xFF34D399);
  static const Color statusPlaying = Color(0xFF38BDF8);

  static const Color textPrimary = Color(0xFFF3F4F6);
  static const Color textSecondary = Color(0xFF9CA3AF);
}
