import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// AppTheme defines Material 3 theme data for dark and light modes.
/// Typography uses Outfit for titles/headings and Inter for body text.
class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    cardColor: AppColors.darkCard,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    border: AppColors.darkBorder,
  );

  static ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    cardColor: AppColors.lightCard,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    border: AppColors.lightBorder,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color border,
  }) {
    final bool isDark = brightness == Brightness.dark;

    final TextTheme outfitHeadlineTheme = GoogleFonts.outfitTextTheme();
    final TextTheme interBodyTheme = GoogleFonts.interTextTheme();

    final TextTheme baseTextTheme = interBodyTheme.copyWith(
      displayLarge: outfitHeadlineTheme.displayLarge?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
      ),
      displayMedium: outfitHeadlineTheme.displayMedium?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displaySmall: outfitHeadlineTheme.displaySmall?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: outfitHeadlineTheme.headlineLarge?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: outfitHeadlineTheme.headlineMedium?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: outfitHeadlineTheme.headlineSmall?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: outfitHeadlineTheme.titleLarge?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: interBodyTheme.titleMedium?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: interBodyTheme.titleSmall?.copyWith(
        color: textSecondary,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: interBodyTheme.bodyLarge?.copyWith(
        color: textPrimary,
        fontSize: 16.0,
        height: 1.6,
      ),
      bodyMedium: interBodyTheme.bodyMedium?.copyWith(
        color: textSecondary,
        fontSize: 14.5,
        height: 1.6,
      ),
      bodySmall: interBodyTheme.bodySmall?.copyWith(
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        fontSize: 12.5,
        height: 1.5,
      ),
      labelLarge: interBodyTheme.labelLarge?.copyWith(
        color: textPrimary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.black,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        outline: border,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      textTheme: baseTextTheme,
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          fontSize: 14,
        ),
      ),
    );
  }
}
