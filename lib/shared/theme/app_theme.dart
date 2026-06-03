import 'package:flutter/material.dart';

import 'package:emas/shared/theme/color_tokens.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/shared/theme/typography_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: ColorTokens.primary500,
      primaryContainer: ColorTokens.primary100,
      onPrimaryContainer: ColorTokens.primary900,
      secondary: ColorTokens.neutral600,
      onSecondary: ColorTokens.white,
      onSurface: ColorTokens.neutral900,
      error: ColorTokens.error500,
      outline: ColorTokens.neutral200,
      surfaceContainerHighest: ColorTokens.neutral100,
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
        color: ColorTokens.neutral200,
        thickness: 1,
      ),
      scaffoldBackgroundColor: ColorTokens.neutral50,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorTokens.white,
        selectedItemColor: ColorTokens.primary600,
        unselectedItemColor: ColorTokens.neutral400,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ColorTokens.white,
        indicatorColor: ColorTokens.primary600,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {

            //selected item
            return const TextStyle(
              color: ColorTokens.primary600,
              fontWeight: TypographyTokens.semiBold,
            );
          }

          return const TextStyle(
            color: ColorTokens.neutral400,
            fontWeight: FontWeight.normal,
          );
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: ColorTokens.white,
        selectedIconTheme: IconThemeData(color: ColorTokens.primary600),
        unselectedIconTheme: IconThemeData(color: ColorTokens.neutral400),
        selectedLabelTextStyle: TextStyle(
          color: ColorTokens.primary600,
          fontWeight: TypographyTokens.semiBold,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: ColorTokens.primary400,
      onPrimary: ColorTokens.primary900,
      primaryContainer: ColorTokens.primary800,
      onPrimaryContainer: ColorTokens.primary100,
      secondary: ColorTokens.neutral400,
      onSecondary: ColorTokens.neutral900,
      surface: ColorTokens.neutral900,
      onSurface: ColorTokens.neutral100,
      error: ColorTokens.error500,
      onError: ColorTokens.white,
      outline: ColorTokens.neutral700,
      outlineVariant: ColorTokens.neutral800,
      surfaceContainerHighest: ColorTokens.neutral800,
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
      scaffoldBackgroundColor: ColorTokens.neutral900,
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
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
      labelLarge: TextStyle(
        fontSize: TypographyTokens.labelLarge,
        fontWeight: TypographyTokens.medium,
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
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
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
        foregroundColor: colorScheme.primary,
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: colorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
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
        foregroundColor: colorScheme.primary,
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
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(RadiusTokens.md),
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
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
