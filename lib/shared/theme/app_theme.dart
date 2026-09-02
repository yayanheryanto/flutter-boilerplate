import 'package:flutter/material.dart';

import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/shared/theme/typography_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary500,
      primaryContainer: AppColors.primary100,
      onPrimaryContainer: AppColors.primary900,
      secondary: AppColors.neutral600,
      onSecondary: AppColors.white,
      onSurface: AppColors.neutral900,
      error: AppColors.error500,
      outline: AppColors.neutral200,
      surfaceContainerHighest: AppColors.neutral100,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: TypographyTokens.fontFamily,
      textTheme: _buildTextTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      cardTheme: _buildCardTheme(),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral200,
        thickness: 1,
      ),
      scaffoldBackgroundColor: AppColors.neutral50,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary600,
        unselectedItemColor: AppColors.neutral400,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.primary600,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {

            //selected item
            return const TextStyle(
              color: AppColors.primary600,
              fontWeight: TypographyTokens.semiBold,
            );
          }

          return const TextStyle(
            color: AppColors.neutral400,
            fontWeight: FontWeight.normal,
          );
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.white,
        selectedIconTheme: IconThemeData(color: AppColors.primary600),
        unselectedIconTheme: IconThemeData(color: AppColors.neutral400),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.primary600,
          fontWeight: TypographyTokens.semiBold,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primary400,
      onPrimary: AppColors.primary900,
      primaryContainer: AppColors.primary800,
      onPrimaryContainer: AppColors.primary100,
      secondary: AppColors.neutral400,
      onSecondary: AppColors.neutral900,
      surface: AppColors.neutral900,
      onSurface: AppColors.neutral100,
      error: AppColors.error500,
      onError: AppColors.white,
      outline: AppColors.neutral700,
      outlineVariant: AppColors.neutral800,
      surfaceContainerHighest: AppColors.neutral800,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: TypographyTokens.fontFamily,
      textTheme: _buildTextTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      cardTheme: _buildCardTheme(),
      scaffoldBackgroundColor: AppColors.neutral900,
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // ── Display ──────────────────────────────────────────────────────────────
      displayLarge: TextStyle(
        fontSize: TypographyTokens.displayLarge,
        fontWeight: TypographyTokens.bold,
        color: colorScheme.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: TypographyTokens.displayMedium,
        fontWeight: TypographyTokens.bold,
        color: colorScheme.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: TypographyTokens.displaySmall,
        fontWeight: TypographyTokens.bold,
        color: colorScheme.onSurface,
      ),

      // ── Headline ─────────────────────────────────────────────────────────────
      headlineLarge: TextStyle(
        fontSize: TypographyTokens.headlineLarge,
        fontWeight: TypographyTokens.bold,
        color: colorScheme.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: TypographyTokens.headlineMedium,
        fontWeight: TypographyTokens.semiBold,
        color: colorScheme.onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: TypographyTokens.headlineSmall,
        fontWeight: TypographyTokens.semiBold,
        color: colorScheme.onSurface,
      ),

      // ── Title ────────────────────────────────────────────────────────────────
      titleLarge: TextStyle(
        fontSize: TypographyTokens.titleLarge,
        fontWeight: TypographyTokens.semiBold,
        color: colorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: TypographyTokens.titleMedium,
        fontWeight: TypographyTokens.medium,
        color: colorScheme.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: TypographyTokens.titleSmall,
        fontWeight: TypographyTokens.medium,
        color: colorScheme.onSurface,
      ),

      // ── Body ─────────────────────────────────────────────────────────────────
      bodyLarge: TextStyle(
        fontSize: TypographyTokens.bodyLarge,
        fontWeight: TypographyTokens.regular,
        color: colorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: TypographyTokens.bodyMedium,
        fontWeight: TypographyTokens.regular,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: TypographyTokens.bodySmall,
        fontWeight: TypographyTokens.regular,
        color: colorScheme.onSurface.withOpacity(0.7),
      ),

      // ── Label ────────────────────────────────────────────────────────────────
      labelLarge: TextStyle(
        fontSize: TypographyTokens.labelLarge,
        fontWeight: TypographyTokens.medium,
        color: colorScheme.onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: TypographyTokens.labelMedium,
        fontWeight: TypographyTokens.medium,
        color: colorScheme.onSurface,
      ),
      labelSmall: TextStyle(
        fontSize: TypographyTokens.labelSmall,
        fontWeight: TypographyTokens.regular,
        color: colorScheme.onSurface,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: TypographyTokens.titleLarge,
        fontWeight: TypographyTokens.semiBold,
        color: colorScheme.onSurface,
        fontFamily: TypographyTokens.fontFamily,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rounded.md),
        ),
        textStyle: const TextStyle(
          fontSize: TypographyTokens.labelLarge,
          fontWeight: TypographyTokens.semiBold,
          fontFamily: TypographyTokens.fontFamily,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    ColorScheme colorScheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rounded.md),
        ),
        textStyle: const TextStyle(
          fontSize: TypographyTokens.labelLarge,
          fontWeight: TypographyTokens.semiBold,
          fontFamily: TypographyTokens.fontFamily,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        textStyle: const TextStyle(
          fontSize: TypographyTokens.labelLarge,
          fontWeight: TypographyTokens.medium,
          fontFamily: TypographyTokens.fontFamily,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rounded.md),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rounded.md),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rounded.md),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rounded.md),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Rounded.md),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      labelStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.6),
        fontSize: TypographyTokens.bodyMedium,
        fontFamily: TypographyTokens.fontFamily,
      ),
      hintStyle: TextStyle(
        color: colorScheme.onSurface.withOpacity(0.4),
        fontSize: TypographyTokens.bodyMedium,
        fontFamily: TypographyTokens.fontFamily,
      ),
    );
  }

  static CardTheme _buildCardTheme() {
    return CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rounded.lg),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
