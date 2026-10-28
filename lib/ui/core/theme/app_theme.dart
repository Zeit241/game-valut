import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.textPrimary,
      surface: AppColors.backgroundBase,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Inter',
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    // Основные цвета

    // Фон экранов
    scaffoldBackgroundColor: AppColors.backgroundBase,

    bottomSheetTheme: const BottomSheetThemeData(
      dragHandleColor: AppColors.textSecondary,
      dragHandleSize: Size(36, 4),
      backgroundColor: AppColors.surfaceDefault

    ),

    // Поля ввода
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDefault,

      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),

      labelStyle: const TextStyle(fontSize: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2A303D), width: 1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2A303D), width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6750A4), width: 1),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2A303D)),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F5F7),
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surfaceDefault,
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: Color(0xFF2A303D)),
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.backgroundRaised,

      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final bool selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 10,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          color: selected ? AppColors.accent : AppColors.textSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final bool selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.accent : AppColors.textSecondary,
        );
      }),

      // selectedLabelStyle: Te
    ),
  );
}
